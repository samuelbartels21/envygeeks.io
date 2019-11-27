<script>
  import Chart from "chart.js";
  import "../../../node_modules/chart.js/dist/Chart.css";
  import { shuffled as shuffledColors } from "../javascript/colors"
  import { Doughnut as Donut } from "vue-chartjs"
  Chart.platform.disableCSSInjection = true;

  export default {
    name: "DonutChart",
    extends: Donut,
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
