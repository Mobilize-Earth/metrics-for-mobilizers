import Chart from 'chart.js';

const colors = ['#fc577a', '#ffd04c', '#66a4fb', '#62dcde', '#f2b8ff', '#ff6db0', '#a5d7fd', '#f15946'];
const calculateTotal = arrayData => arrayData.reduce((a, b) => a + b, 0);
const calculateExistingMemberPercentage = (newParticipants, totalParticipants) =>  100 - ((newParticipants / totalParticipants) * 100)
const removeNewMembersFromCount = (newParticipants, totalParticipants) => totalParticipants.map((count, index) => count - newParticipants[index]);
const createMetricsDiv = (label, color, newParticipants, totalParticipants) => {
    const percentOfNonNewMembers = calculateExistingMemberPercentage(calculateTotal(newParticipants), calculateTotal(totalParticipants));
    return `<div class="metric">
        <div class="title">${totalParticipants}</div>
        <div class="visual" style="background: linear-gradient(90deg, ${color} ${percentOfNonNewMembers - 1}%, #E01A4F ${percentOfNonNewMembers}%);"></div>
        <div class="subtitle">${label}</div>
    </div>`;
}

export default {
    initMobilizationsChart: chartData => {
        const datasets = [];
        const metrics = [];
        let count = 0;

        for(const data of chartData.data) {
            datasets.push({
                label: `${data.label} / New Members`,
                backgroundColor: '#E01A4F',
                data: data.new,
                stack: count });

            datasets.push({
                label: `${data.label} / Existing Members`,
                backgroundColor: colors[count],
                data: removeNewMembersFromCount(data.new, data.participants),
                stack: count });

            metrics.push(createMetricsDiv(data.label, colors[count], data.new, data.participants));

            count++;
        }

        $('.mobilization-metrics-container').html(metrics);

        new Chart('chart', {
            type: 'bar',
            data: {
                labels: chartData.labels,
                datasets
            },
            options: chartOptions
        })
    }
};

const chartOptions = {
    title: {
        display: false
    },
    legend: {
        display: false
    },
    tooltips: {},
    maintainAspectRatio: false,
    scales: {
        xAxes: [{
            stacked: true,
        }],
        yAxes: [{
            stacked: true
        }]
    }
};