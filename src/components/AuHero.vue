<template>
  <div class="Hero__main-container">
    <AuCanvas />
    <h1 class="Hero__text">We build digital products that your customers love.</h1>
  </div>
</template>
<script lang="ts" setup>
import AuCanvas from '../components/AuCanvas.vue'
</script>
<style lang="scss" scoped>
.Hero {
  &__main-container {
    max-width: 1160px;
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    margin: 0 auto;
    position: relative;
  }

  &__text {
    font-size: 85px;
    color: #222222;
    font-weight: 500;
    display: flex;
    flex-direction: column;
    justify-content: center;
    line-height: 1.07;
    align-content: center;
    text-align: center;
    margin: 318px auto 0;
  }
}
</style>
