<script>
  import { Doughnut as Donut } from "vue-chartjs";
  import { shuffled } from "~/assets/colors";

  export default {
    extends: Donut,
    name: "donut",
    props: [
      "labels",
      "values"
    ],

    mounted () {
      this.renderChart({
        labels: this.labels,
        datasets: [{
          backgroundColor: shuffled(),
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
