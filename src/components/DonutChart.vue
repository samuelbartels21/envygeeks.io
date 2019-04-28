<script>
  import { shuffledColors } from "~/assets/colors"
  import { Doughnut as Donut } from "vue-chartjs"

  export default {
    extends: Donut,
    name: "Donut",
    props: {
      labels: {
        required: true,
        type: Array
      },
      values: {
        required: true,
        type: Array
      }
    },

    mounted () {
      this.renderChart({
        labels: this.labels,
        datasets: [{
          backgroundColor: shuffledColors(),
          data: this.values
        }]
      }, {
        legend: {
          display: false
        }
      })
    }
  }
</script>
