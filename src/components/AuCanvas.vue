<template>
  <TresCanvas
    class="aucanvas"
    clear-color="#ffffff"
    :antialias="true"
    preset="realistic"
    window-size
  >
    <TresPerspectiveCamera :position="[0, 0, 13]" :args="[45, 1, 0.1, 1000]" />
    <!-- <OrbitControls /> -->
    <TresDirectionalLight :intensity="1" :position="[30, 20, 10]" castShadow />
    <TresHemisphereLight :intensity="1" :color="0xffffff" :ground-color="0xffffff" />
    >
    <Suspense>
      <AuModel />
    </Suspense>
    <!-- <Reflector :rotation="[-Math.PI * 0.5, 0, 0]" :position="[0, -3, 0]" color="#f7f7f7">
        <TresCircleGeometry :args="[10, 32]" />
      </Reflector> -->
  </TresCanvas>
</template>

<script lang="ts" setup>
import AuModel from '../components/AuModel.vue'
import { ref } from 'vue'
import { TresCanvas } from '@tresjs/core'
// import { OrbitControls, MeshWobbleMaterial, Reflector, Stars } from '@tresjs/cientos'
</script>

<style lang="scss">
.aucanvas {
  z-index: -1 !important;
  position: absolute !important;
  left: 50% !important;
  top: 85% !important;
  transform: translate(-50%, -50%) !important;
}
</style>
