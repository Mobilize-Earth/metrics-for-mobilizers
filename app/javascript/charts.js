import Chart from 'chart.js';

const colors = ['#fc577a', '#ffd04c', '#66a4fb', '#62dcde', '#f2b8ff', '#ff6db0', '#a5d7fd', '#f15946'];
const calculateTotal = arrayData => arrayData.reduce((a, b) => a + b, 0);
const calculateTotalAsMoney = arrayData => `$${calculateTotal(arrayData.map(x => parseFloat(x))).toFixed(2)}`;
const removeNewMembersFromCount = (newParticipants, totalParticipants) => totalParticipants.map((count, index) => count - newParticipants[index]);
const createMetricsDiv = (label, color, value) => `<div class="metric">
    <div class="visual" style="background-color: ${color};"></div>
    <div class="subtitle">${label}</div>
    <div class="title">${value}</div>
</div>`;
const totalParticipantsDiv = () => `<div class="metric total-metric">
    <div class="visual" style="background-color: #a6a6a6;"></div>
    <div class="subtitle">Total Participants</div>
    <div class="description">Represents total grouped activity</div>
</div>`;

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
            stacked: true,
            ticks: {
                suggestedMin: 0
            }
        }]
    }
};

const mobilizationParticipants = chartData => {
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
            label: `${data.label} / Non-Converted`,
            backgroundColor: '#a6a6a6',
            data: removeNewMembersFromCount(data.new, data.participants),
            stack: count });

        metrics.push(createMetricsDiv(data.label, colors[count], calculateTotal(data.new)));
        count++;
    }

    metrics.push(totalParticipantsDiv());

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
};

const mobilizationSubscriptions = chartData => {
    const datasets = [];
    const metrics = [];
    let count = 0;

    for(const data of chartData.data) {
        datasets.push({
            label: `${data.label} / Total Subscriptions`,
            backgroundColor: colors[count],
            data: data.total_one_time_donations,
            minBarLength: 2,
            stack: count });

        metrics.push(createMetricsDiv(data.label, colors[count], calculateTotalAsMoney(data.total_one_time_donations)));
        count++;
    }

    $('.mobilization-metrics-container-subscriptions').html(metrics);
    $('.mobilizations-chart-subscriptions').html('<canvas id="mobilizations-subscriptions-chart"></canvas>');

    const options = {
        title: {
            display: false
        },
        legend: {
            display: false
        },
        tooltips: {
            callbacks: {
                label: function (tooltipItem, data) {
                    var label = data.datasets[tooltipItem.datasetIndex].label || '';
                    if (label) {
                        label += ': ';
                    }
                    label += '$' + tooltipItem.value;
                    return label;
                }
            }
        },
        maintainAspectRatio: false,
        scales: {
            yAxes: [{
                ticks: {
                    callback: function (value) {
                        return '$' + value;
                    },
                    suggestedMin: 0
                }
            }]
        }
    };
    new Chart('mobilizations-subscriptions-chart', {
        type: 'bar',
        data: {
            labels: chartData.labels,
            datasets
        },
        options: options
    })
};

const mobilizationArrestablePledges = chartData => {
    const datasets = [];
    const metrics = [];
    let count = 0;

    for(const data of chartData.data) {
        datasets.push({
            label: `${data.label} / Total Arrestable Pledges`,
            backgroundColor: colors[count],
            data: data.arrestable_pledges,
            minBarLength: 2,
            stack: count });

        metrics.push(createMetricsDiv(data.label, colors[count], calculateTotal(data.arrestable_pledges)));
        count++;
    }

    $('.mobilization-metrics-container-arrestable-pledges').html(metrics);
    $('.mobilizations-chart-arrestable-pledges').html('<canvas id="mobilizations-arrestable-pledges-chart"></canvas>');

    new Chart('mobilizations-arrestable-pledges-chart', {
        type: 'bar',
        data: {
            labels: chartData.labels,
            datasets
        },
        options: chartOptions
    })
};

const Charts = {
    initMobilizationsChart: chartData => {
        mobilizationParticipants(chartData);
        mobilizationSubscriptions(chartData);
        mobilizationArrestablePledges(chartData);
    }
};

export default Charts;