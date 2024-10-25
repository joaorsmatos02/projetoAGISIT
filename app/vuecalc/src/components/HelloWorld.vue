<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.description {
  text-align: left; 
  font-size: 20px; 
  font-weight:600; 
  margin-left: 125px;
}
a {
  color: #42b983;
}
</style>
