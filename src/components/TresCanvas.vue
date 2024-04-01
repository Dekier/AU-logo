<template>
  <TresCanvas clear-color="#82DBC5" :antialias="isActiveAntialias">
    <TresPerspectiveCamera :position="[50, 50, 50]" :args="[45, 1, 0.1, 1000]" />
    <OrbitControls :auto-rotate="true" :auto-rotate-speed="0.5" />
    <TresAmbientLight :intensity="1" :visible="isActiveAmbientLight" />
    <TresDirectionalLight
      :intensity="1"
      :position="[-3, 20, -2]"
      :visible="isActiveDirectionalLight"
    />
    <TresHemisphereLight
      :intensity="1.0"
      :color="0xffffff"
      :ground-color="0xffffff"
      :visible="isActiveHemisphereLight"
    />

    <template v-for="box in boxes" :key="box.id">
      <Box :args="[1, 1, 1]" :position="box.position">
        <TresMeshToonMaterial v-if="selectedMaterial === 'Toon'" :color="box.color" />
        <TresMeshBasicMaterial v-else-if="selectedMaterial === 'Basic'" :color="box.color" />
        <TresMeshStandardMaterial
          v-else-if="selectedMaterial === 'Standard'"
          :color="box.color"
          :metalness="0.9"
          :roughness="0.1"
        />
        <TresMeshLambertMaterial v-else-if="selectedMaterial === 'Lambert'" :color="box.color" />
        <TresMeshPhongMaterial v-else-if="selectedMaterial === 'Phong'" :color="box.color" />
        <TresMeshPhysicalMaterial
          v-else-if="selectedMaterial === 'Physical'"
          :color="box.color"
          :metalness="0.5"
          :roughness="0.2"
        />
      </Box>
    </template>
  </TresCanvas>
</template>

<script setup lang="ts">
const emit = defineEmits(['setBoxesCount'])
import { TresCanvas, useRenderLoop, useTresContext } from '@tresjs/core'
import { OrbitControls, Box } from '@tresjs/cientos'
import { ref, onMounted, watch, shallowRef, nextTick } from 'vue'

const props = defineProps({
  stopTest: {
    type: Boolean,
    required: true
  },
  selectedMaterial: {
    type: String,
    required: true
  },
  isActiveAmbientLight: {
    type: Boolean,
    required: true
  },
  isActiveDirectionalLight: {
    type: Boolean,
    required: true
  },
  isActiveHemisphereLight: {
    type: Boolean,
    required: true
  },
  isActiveAntialias: {
    type: Boolean,
    required: true
  }
})

// const { scene } = useTresContext()

const boxes = ref([])

const createBox = () => {
  const x = Math.random() * 40 - 20
  const y = Math.random() * 40 - 20
  const z = Math.random() * 40 - 20
  const color =
    '#' +
    Math.floor(Math.random() * 16777215)
      .toString(16)
      .padStart(6, '0') // Upewnienie się, że kolor ma dokładnie 6 znaków
  return { id: Date.now(), position: [x, y, z], color }
}
let timer = 0 as number
watch(
  () => props.stopTest,
  (value) => {
    if (value) {
      clearInterval(timer)
      timer = 0
    }
  }
)
onMounted(async () => {
  await nextTick()
  console.log(props)
  timer = 0
  timer = window.setInterval(() => {
    boxes.value.push(createBox())
    emit('setBoxesCount', boxes.value.length)
    // setData()
  }, 200)
})
// const { onLoop } = useRenderLoop()
// onLoop(() => {
//   if (controllerIndex.value !== null) {
//     controllerInput()
//     updatePlayer()
//   }
// })
// const canvasRef = shallowRef()

// watch(canvasRef, (value) => {
//   console.log(value) // you get the context
// })
</script>

<style lang="scss"></style>
