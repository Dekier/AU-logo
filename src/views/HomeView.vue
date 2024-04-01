<template>
  <div class="MainPage__main-container">
    <div class="MainPage__top-container">
      <div class="MainPage__info-container">
        <h1 class="MainPage__title">Informations</h1>
        <p class="MainPage__text">Boxes (1,1,1) Count: {{ boxesCount }}</p>
        <p class="MainPage__text">Vertices: {{ boxesCount * 8 }}</p>
        <p class="MainPage__text">Edges: {{ boxesCount * ((4 * 6) / 2) }}</p>
        <p class="MainPage__text">Faces: {{ boxesCount * 6 }}</p>
        <p class="MainPage__text">Triangles: {{ boxesCount * 24 }}</p>
        <p class="MainPage__text-bold">FPS: {{ fps }}</p>
      </div>
      <div class="MainPage__settings-container">
        <h1 class="MainPage__title">Settings</h1>
        <p class="MainPage__text">Type: Mesh (soon)</p>
        <p class="MainPage__text">
          Antialias:
          <div class="MainPage__checkbox" @click="isActiveAntialias = !isActiveAntialias">
            <div
              class="MainPage__checkbox-line"
              :class="{ 'MainPage__checkbox-line--active': isActiveAntialias }"
            />
            <div
              class="MainPage__checkbox-dot"
              :class="{ 'MainPage__checkbox-dot--active': isActiveAntialias }"
            />
          </div>
        </p>
        <p class="MainPage__text">
          AmbientLight:
          <div class="MainPage__checkbox" @click="isActiveAmbientLight = !isActiveAmbientLight">
            <div
              class="MainPage__checkbox-line"
              :class="{ 'MainPage__checkbox-line--active': isActiveAmbientLight }"
            />
            <div
              class="MainPage__checkbox-dot"
              :class="{ 'MainPage__checkbox-dot--active': isActiveAmbientLight }"
            />
          </div>
        </p>
        <p class="MainPage__text">
          DirectionalLight:
          <div class="MainPage__checkbox" @click="isActiveDirectionalLight = !isActiveDirectionalLight">
            <div
              class="MainPage__checkbox-line"
              :class="{ 'MainPage__checkbox-line--active': isActiveDirectionalLight }"
            />
            <div
              class="MainPage__checkbox-dot"
              :class="{ 'MainPage__checkbox-dot--active': isActiveDirectionalLight }"
            />
          </div>
        </p>
        <p class="MainPage__text">
          HemisphereLight:
          <div class="MainPage__checkbox" @click="isActiveHemisphereLight = !isActiveHemisphereLight">
            <div
              class="MainPage__checkbox-line"
              :class="{ 'MainPage__checkbox-line--active': isActiveHemisphereLight }"
            />
            <div
              class="MainPage__checkbox-dot"
              :class="{ 'MainPage__checkbox-dot--active': isActiveHemisphereLight }"
            />
          </div>
        </p>

        <p class="MainPage__text">
          Material:
          <select class="MainPage__select" v-model="selectedMaterial">
            <option>Basic</option>
            <option>Standard</option>
            <option>Lambert</option>
            <option>Phong</option>
            <option>Physical</option>
            <option>Toon</option>
          </select>
        </p>

        <button class="MainPage__button" type="button" @click="isActiveTest = true">
          Start Test
        </button>
      </div>
    </div>
    <div class="MainPage__canvas">
      <TresCanvas
        v-if="isActiveTest"
        :key="canvasKey"
        :stop-test="stopTest"
        :selected-material="selectedMaterial"
        :is-active-ambient-light="isActiveAmbientLight"
        :is-active-directional-light="isActiveDirectionalLight"
        :is-active-hemisphere-light="isActiveHemisphereLight"
        :is-active-antialias="isActiveAntialias"
        @setBoxesCount="setBoxesCount"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import TresCanvas from '../components/TresCanvas.vue'
import { useRenderLoop, useTresContext } from '@tresjs/core'
import { OrbitControls, Box } from '@tresjs/cientos'
import { ref, onMounted, watch } from 'vue'
import { Mesh } from 'three'

const boxesCount = ref(0)
let isActiveTest = ref(false)
let fps = ref(0)
let stopTest = ref(false)
let canvasKey = ref('fklsnflksndfkls')
const selectedMaterial = ref('Basic')
const isActiveAmbientLight = ref(false)
const isActiveDirectionalLight = ref(false)
const isActiveHemisphereLight = ref(false)
const isActiveAntialias = ref(false)

const setBoxesCount = (value) => {
  boxesCount.value = value
}

const generateRandomKey = (length) => {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';

  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  console.log('lol:', result)

  return result;
}

watch(isActiveAntialias, (value) => {
  canvasKey.value = generateRandomKey(10)
})
watch(selectedMaterial, (value) => {
  console.log('lol', generateRandomKey(10))
  canvasKey.value = generateRandomKey(10)
})

watch(fps, (value) => {
  if (value < 50) {
    stopTest.value = true
  }
})

const { onLoop } = useRenderLoop()
let frames = 0
let prevTime = performance.now()
onLoop(({ _delta, elapsed }) => {
  frames++
  const time = performance.now()

  if (time >= prevTime + 1000) {
    fps.value = Math.round((frames * 1000) / (time - prevTime))
    frames = 0
    prevTime = time
  }
})
</script>

<style lang="scss">
.MainPage {
  &__main-container {
    display: flex;
    flex-direction: column;
  }

  &__canvas {
    width: 700px;
    height: 700px;
  }

  &__top-container {
    margin-bottom: 32px;
    display: flex;
  }

  &__text {
    font-size: 16px;
    margin-bottom: 12px;
    display: flex;
    flex-direction: row;
  }

  &__text-bold {
    font-size: 20px;
    font-weight: 600;
    color: rgba($color: #ffffff, $alpha: 0.8);
  }

  &__button {
    font-size: 18px;
    margin-bottom: 12px;
    padding: 4px 8px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: transparent;
    color: rgba($color: #ffffff, $alpha: 0.8);
    cursor: pointer;
    &:hover {
      color: rgba($color: #ffffff, $alpha: 1);
      border: 1px solid #ffffff;
    }
  }

  &__select {
    font-size: 16px;
    margin-left: 12px;
    padding: 4px 8px;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: transparent;
    color: rgba($color: #ffffff, $alpha: 0.8);
    cursor: pointer;
    &:hover {
      color: rgba($color: #ffffff, $alpha: 1);
      border: 1px solid #ffffff;
    }
    option {
      background: rgba(0, 0, 0, 0.7);
      color: #fff;
      cursor: pointer;
    }
  }

  &__info-container {
    display: flex;
    flex-direction: column;
    width: 300px;
  }

  &__checkbox {
    display: flex;
    margin: auto 0 8px 12px;
    width: 25px;
    height: 10px;
    border-radius: 5px;
    border: 2px solid rgba($color: #ffffff, $alpha: 0.5);
    background: transparent;
    position: relative;
    cursor: pointer;
    &:hover {
      border: 2px solid rgba($color: #ffffff, $alpha: 1);
    }
  }

  &__checkbox-line {
    width: 6px;
    height: 6px;
    border-radius: 5px;
    left: 0;
    top: 0;
    background-color: rgba($color: #ffffff, $alpha: 0.5);
    position: absolute;
    cursor: pointer;
    transition: width 300ms;
    &:hover {
      background-color: rgba($color: #ffffff, $alpha: 1);
    }

    &--active {
      width: 25px;
    }
  }

  &__checkbox:hover &__checkbox-line {
    background-color: rgba($color: #ffffff, $alpha: 1);
  }

  &__checkbox-dot {
    position: absolute;
    width: 17px;
    height: 17px;
    background-color: rgba($color: #ffffff, $alpha: 1);
    left: -10px;
    top: 50%;
    transform: translate(0, -50%);
    border-radius: 50%;
    transition: transform 300ms;

    &--active {
      transform: translate(calc(100% + 7px), -50%);
    }
  }
}
</style>
