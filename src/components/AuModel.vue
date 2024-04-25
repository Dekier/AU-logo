<script lang="ts" setup>
import { useTresContext, useRenderLoop } from '@tresjs/core'
import gsap from 'gsap'
import {
  BufferAttribute,
  BufferGeometry,
  ShaderMaterial,
  Uniform,
  Vector2,
  Points,
  UniformsLib,
  MeshPhysicalMaterial
} from 'three'
import { useGLTF, Sampler, useSurfaceSampler, Plane, MeshGlassMaterial } from '@tresjs/cientos'
import { onMounted, nextTick, ref, watch, shallowRef } from 'vue'
const { onLoop } = useRenderLoop()
import { GPUComputationRenderer } from 'three/addons/misc/GPUComputationRenderer.js'
import particlesVertexShader from '../shaders/particles/vertex.glsl'
import particlesFragmentShader from '../shaders/particles/fragment.glsl'
import gpgpuParticlesShader from '../shaders/gpgpu/particles.glsl'
const { scene, renderer, camera } = useTresContext()
const { nodes } = await useGLTF('/models/au.glb', { draco: true })
const { nodes: nodesModel1 } = await useGLTF('/models/model1.glb', { draco: true })
console.log(nodesModel1)
const baseGeometry = {}
const gpgpu = {}
let baseParticlesTexture = null
baseGeometry.instance = nodes.au.geometry
baseGeometry.count = baseGeometry.instance.attributes.position.count
onMounted(() => {
  setTimeout(() => {
    // updateGeometry(nodesModel1.Circle.geometry)
  }, 3000) // Delay update by 3000 milliseconds (3 seconds)
})
/**
 * Sizes
 */
const sizes = {
  width: window.innerWidth,
  height: window.innerHeight,
  pixelRatio: Math.min(window.devicePixelRatio, 2)
}

gpgpu.size = Math.ceil(Math.sqrt(baseGeometry.count))
gpgpu.computation = new GPUComputationRenderer(gpgpu.size, gpgpu.size, renderer.value)

// Base particles
baseParticlesTexture = gpgpu.computation.createTexture()

for (let i = 0; i < baseGeometry.count; i++) {
  const i3 = i * 3
  const i4 = i * 4

  // Position based on geometry
  baseParticlesTexture.image.data[i4 + 0] = baseGeometry.instance.attributes.position.array[i3 + 0]
  baseParticlesTexture.image.data[i4 + 1] = baseGeometry.instance.attributes.position.array[i3 + 1]
  baseParticlesTexture.image.data[i4 + 2] = baseGeometry.instance.attributes.position.array[i3 + 2]
  baseParticlesTexture.image.data[i4 + 3] = Math.random()
}

// Particles variable
gpgpu.particlesVariable = gpgpu.computation.addVariable(
  'uParticles',
  gpgpuParticlesShader,
  baseParticlesTexture
)
gpgpu.computation.setVariableDependencies(gpgpu.particlesVariable, [gpgpu.particlesVariable])
const uniformsData = {
  uFlowFieldInfluence: 0
}
// Uniforms
gpgpu.particlesVariable.material.uniforms.uTime = new Uniform(0)
gpgpu.particlesVariable.material.uniforms.uDeltaTime = new Uniform(0)
gpgpu.particlesVariable.material.uniforms.uBase = new Uniform(baseParticlesTexture)
gpgpu.particlesVariable.material.uniforms.uFlowFieldInfluence = new Uniform(
  uniformsData.uFlowFieldInfluence
)
gpgpu.particlesVariable.material.uniforms.uFlowFieldStrength = new Uniform(
  uniformsData.uFlowFieldInfluence
)
gpgpu.particlesVariable.material.uniforms.uFlowFieldFrequency = new Uniform(
  uniformsData.uFlowFieldInfluence
)
document.addEventListener('mousemove', function (event) {
  const width = window.innerWidth
  const fullHeight = window.innerHeight
  const height = fullHeight * 0.85 // Używamy tylko 85% wysokości ekranu
  const centerX = width / 2
  const centerY = fullHeight * 0.5 - fullHeight * 0.25 // Centrum przesunięte o 25% w górę

  const neutralZoneSize = 100 // Połowa z 300px

  // Obliczenie odległości kursora od środka ekranu
  const distanceX = Math.abs(event.clientX - centerX)
  const distanceY = Math.abs(event.clientY - centerY)

  // Odległość od środka ekranu poza "strefą neutralną"
  const effectiveDistanceX = Math.max(0, distanceX - neutralZoneSize)
  const effectiveDistanceY = Math.max(0, distanceY - neutralZoneSize)

  // Maksymalna odległość od "strefy neutralnej" do krawędzi, uwzględniając zmienione wymiary
  const maxDistanceX = width / 2 - neutralZoneSize
  const maxDistanceY = height / 2 + fullHeight * 0.075 - neutralZoneSize // Korekta maksymalnej odległości Y

  // Znalezienie maksymalnej odległości w obu kierunkach (poziomo lub pionowo)
  const maxDistance = Math.sqrt(maxDistanceX ** 2 + maxDistanceY ** 2)

  // Obliczenie bieżącej odległości od "strefy neutralnej"
  const currentDistance = Math.sqrt(effectiveDistanceX ** 2 + effectiveDistanceY ** 2)

  // Skalowanie obecnej odległości do zakresu od 0 do 2
  const scaledValue = (currentDistance / maxDistance) * 2
  const clampedValue = Math.min(scaledValue, 2) // Zapewniamy, że wartość nie przekroczy 2

  gpgpu.particlesVariable.material.uniforms.uFlowFieldInfluence = new Uniform(clampedValue)
  gpgpu.particlesVariable.material.uniforms.uFlowFieldStrength = new Uniform(clampedValue)
  gpgpu.particlesVariable.material.uniforms.uFlowFieldFrequency = new Uniform(clampedValue)
})

// Init
gpgpu.computation.init()

/**
 * Particles
 */
const particles = {}

// Geometry
const particlesUvArray = new Float32Array(baseGeometry.count * 2)
const sizesArray = new Float32Array(baseGeometry.count)

for (let y = 0; y < gpgpu.size; y++) {
  for (let x = 0; x < gpgpu.size; x++) {
    const i = y * gpgpu.size + x
    const i2 = i * 2

    // UV
    const uvX = (x + 0.5) / gpgpu.size
    const uvY = (y + 0.5) / gpgpu.size

    particlesUvArray[i2 + 0] = uvX
    particlesUvArray[i2 + 1] = uvY

    // Size
    sizesArray[i] = Math.random()
  }
}

particles.geometry = new BufferGeometry()
particles.geometry.setDrawRange(0, baseGeometry.count)
particles.geometry.setAttribute('aParticlesUv', new BufferAttribute(particlesUvArray, 2))
particles.geometry.setAttribute('aSize', new BufferAttribute(sizesArray, 1))

// Material
particles.material = new ShaderMaterial({
  vertexShader: particlesVertexShader,
  fragmentShader: particlesFragmentShader,
  uniforms: {
    uSize: new Uniform(0.1),
    uResolution: new Uniform(
      new Vector2(sizes.width * sizes.pixelRatio, sizes.height * sizes.pixelRatio)
    ),
    uParticlesTexture: new Uniform()
  }
})

// Points
particles.points = new Points(particles.geometry, particles.material)
scene.value.add(particles.points)

onLoop(({ delta, elapsed }) => {
  // GPGPU Update
  gpgpu.particlesVariable.material.uniforms.uTime.value = elapsed
  gpgpu.particlesVariable.material.uniforms.uDeltaTime.value = delta
  gpgpu.computation.compute()
  particles.material.uniforms.uParticlesTexture.value = gpgpu.computation.getCurrentRenderTarget(
    gpgpu.particlesVariable
  ).texture
})
</script>

<style lang="scss"></style>
