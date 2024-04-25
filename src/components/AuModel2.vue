<template>
  <!-- <Sampler :count="50"> -->
  <Suspense>
    <primitive :object="nodes.au" ref="torusRef" />
  </Suspense>
  <!-- <Box :args="[1, 1, 1]" color="orange" ref="torusRef" /> -->
  <!-- <TresInstancedMesh ref="instancesRef" :args="[null!, null!, 10000]">
      <TresSphereGeometry :args="[0.13, 10, 10]" />
      <TresMeshNormalMaterial />
    </TresInstancedMesh>
  </Sampler> -->
</template>

<script lang="ts" setup>
import { useTresContext, useRenderLoop } from '@tresjs/core'
import {
  BufferAttribute,
  BufferGeometry,
  ShaderMaterial,
  Uniform,
  Vector2,
  Points,
  UniformsLib
} from 'three'
import { useGLTF, Sampler, useSurfaceSampler, Box } from '@tresjs/cientos'
import { onMounted, nextTick, ref, watch } from 'vue'
const { onLoop } = useRenderLoop()
import vertexShader from '../shaders/test/vertex.glsl'
import fragmentShader from '../shaders/test/fragment.glsl'
const { scene, renderer, camera } = useTresContext()
const { nodes } = await useGLTF('/models/au.glb', { draco: true })
console.log(nodes)

const material = new ShaderMaterial({
  vertexShader,
  fragmentShader,
  uniforms: {
    mousePos: { value: new Vector2(-1, -1) }
  }
})
// const torusRef = ref()

// watch(torusRef, (value) => {
//   console.log(value.material)
//   value.material = material
// })

document.addEventListener('mousemove', (event) => {
  const x = (event.clientX / window.innerWidth) * 2 - 1
  const y = -(event.clientY / window.innerHeight) * 2 + 1
  material.uniforms.mousePos.value.set(x, y)
})
</script>

<style lang="scss"></style>
