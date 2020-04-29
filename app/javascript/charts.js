import Chart from 'chart.js';

const colors = ['#fc577a', '#ffd04c', '#66a4fb', '#62dcde', '#f2b8ff', '#ff6db0', '#a5d7fd', '#f15946'];
const calculateTotal = arrayData => arrayData.reduce((a, b) => a + b, 0);
const calculateExistingMemberPercentage = (newParticipants, totalParticipants) =>  100 - ((newParticipants / totalParticipants) * 100)
const removeNewMembersFromCount = (newParticipants, totalParticipants) => totalParticipants.map((count, index) => count - newParticipants[index]);
const createMetricsDiv = (label, color, newParticipants, totalParticipants) => {
    const percentOfNonNewMembers = calculateExistingMemberPercentage(newParticipants, totalParticipants);
    return `<div class="metric">
        <div class="title">${totalParticipants}</div>
        <div class="visual" style="background: linear-gradient(90deg, #a6a6a6 ${percentOfNonNewMembers - 1}%, ${color} ${percentOfNonNewMembers}%);"></div>
        <div class="subtitle">${label}</div>
    </div>`;
}

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

const Charts = {
    initMobilizationsChart: chartData => {
        const newMemberCount = calculateTotal(chartData.data.map(data => calculateTotal(data.new)));
        const participantCount = calculateTotal(chartData.data.map(data => calculateTotal(data.participants)));

        const datasets = [];
        const metrics = [];
        let count = 0;

        for(const data of chartData.data) {
            datasets.push({
                label: `${data.label} / New Members`,
                backgroundColor: colors[count],
                data: data.new,
                minBarLength: 2,
                stack: count });

            datasets.push({
                label: `${data.label} / Participants`,
                backgroundColor: '#a6a6a6',
                data: removeNewMembersFromCount(data.new, data.participants),
                stack: count });

            metrics.push(createMetricsDiv(data.label, colors[count], calculateTotal(data.new), calculateTotal(data.participants)));

            count++;
        }

        $('#average-new-members').html(newMemberCount);
        $('#average-participants').html(participantCount);
        $('.mobilization-metrics-container').html(metrics);
        $('.mobilizations-chart').html('<canvas id="mobilizations-chart"></canvas>');

        new Chart('mobilizations-chart', {
            type: 'bar',
            data: {
                labels: chartData.labels,
                datasets
            },
            options: chartOptions
        })
    }
};

export default Charts;