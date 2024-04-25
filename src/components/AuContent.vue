<template>
  <div class="Content__main-container">
    <h2 class="Content__title">
      We are a development agency with expertise in Tech & Product empowering your digital product
      at any stage or size:
    </h2>
    <div class="Content__buttons-container">
      <div class="Content__button-container">
        <div class="Content__small-text">IF YOU HAVE A</div>
        <div class="Content__big-text">Product Idea</div>
      </div>
      <div class="Content__button-container">
        <div class="Content__small-text">IF YOU WANT A</div>
        <div class="Content__big-text">Product Release</div>
      </div>
      <div class="Content__button-container">
        <div class="Content__small-text">IF YOU NEED A</div>
        <div class="Content__big-text">Product Scale Up</div>
      </div>
      <div class="Content__button-container">
        <div class="Content__small-text">IF YOU NEED A</div>
        <div class="Content__big-text">Digital Transformation</div>
      </div>
    </div>
    <div class="Content__center-container">
      <p class="Content__text">
        Our team specializes in transforming businesses, ensuring you leverage the latest
        technologies and methodologies. From strategy to execution, we'll revitalize your
        operations, making you more agile and efficient.
      </p>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.Content {
  &__main-container {
    max-width: 1160px;
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    margin: 338px auto 300px;
  }

  &__title {
    font-size: 35px;
    color: #222222;
    font-weight: 500;
    cursor: pointer;
    line-height: 1.5;
    align-content: center;
    text-align: left;
    margin: 0px 0 100px;
    max-width: 725px;
  }

  &__buttons-container {
    display: flex;
    flex-direction: flex;
    justify-content: space-between;
  }

  &__button-container {
    display: flex;
    flex-direction: column;
    cursor: pointer;
  }

  &__small-text {
    font-size: 16px;
    color: #222222;
    font-weight: 600;
    margin-bottom: 12px;
  }

  &__big-text {
    font-size: 28px;
    color: #222222;
    font-weight: 500;
  }

  &__center-container {
    display: flex;
    margin: 80px 0;
  }

  &__text {
    font-size: 22px;
    color: #222222;
    font-weight: 400;
    line-height: 1.9;
    max-width: 595px;
    margin-left: auto;
  }
}
</style>
