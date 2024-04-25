<template>
  <div class="Header__main-container">
    <img src="/images/logo.svg" class="Header__logo" />
    <div class="Header__buttons-container">
      <n-link to="/#" class="Header__button">Career</n-link>
      <n-link to="/#" class="Header__button">Blog</n-link>
      <n-link to="/#" class="Header__button-green">Get in touch</n-link>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.Header {
  &__main-container {
    position: fixed;
    top: 0;
    left: 50%;
    transform: translateX(-50%);
    z-index: 100;
    max-width: 1160px;
    width: 100%;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    padding: 20px 0;
    height: 50px;
  }

  &__logo {
    width: 87px;
  }

  &__buttons-container {
    display: flex;
    width: 350px;
    justify-content: space-between;
  }

  &__button {
    font-size: 16px;
    color: #222222;
    font-weight: 600;
    display: flex;
    flex-direction: column;
    justify-content: center;
    cursor: pointer;
    &:hover {
      color: #8acc56;
    }
  }

  &__button-green {
    width: 135px;
    font-size: 16px;
    color: #222222;
    font-weight: 600;
    display: flex;
    flex-direction: column;
    justify-content: center;
    background-color: #8acc56;
    cursor: pointer;
    align-items: center;
    border-radius: 30px;

    &:hover {
      background-color: #a0d575;
    }
  }
}
</style>
