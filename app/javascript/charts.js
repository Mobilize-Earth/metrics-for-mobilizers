import Chart from 'chart.js';

const colors = ['#fc577a', '#ffd04c', '#66a4fb', '#62dcde', '#f2b8ff', '#ff6db0', '#a5d7fd', '#f15946'];

export default {
    initChart: chartData => {
        const maxMetric = Math.max(...chartData.metrics.map(metric => metric.value));

        let count = 0;
        for(const metric of chartData.metrics) {
            $(metric.label).html(metric.value);

            const percentageOfMax = (metric.value / maxMetric) * 100;
            $(metric.visualLabel).css('background',
                `linear-gradient(90deg, ${colors[count]} ${percentageOfMax - 1}%, #f4f7f6 ${percentageOfMax}%)`);

            count++;
        }

        const datasets = [];
        count = 0;

        for(const data of chartData.data) {
            datasets.push({
                label: `${data.label} / New Members`,
                backgroundColor: '#666',
                data: data.new,
                stack: count });

            datasets.push({
                label: `${data.label}`,
                backgroundColor: colors[count],
                data: data.participants,
                stack: count });

            count++;
        }

        new Chart('chart', {
            type: 'bar',
            data: {
                labels: chartData.labels,
                datasets
            },
            options: {
                title: {
                    display: false
                },
                legend: {
                    display: false
                },
                tooltips: {
                    mode: 'index',
                    intersect: false
                },
                maintainAspectRatio: false,
                scales: {
                    xAxes: [{
                        stacked: true,
                    }],
                    yAxes: [{
                        stacked: true
                    }]
                }
            }
        })
    }
};