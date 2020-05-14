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
    <div class="subtitle">People Engaged</div>
    <div class="description">Total grouped activity</div>
</div>`;
const getParticipants = chartData => {
   const participants = [];

    for(const labelIndex in chartData.labels) {
        const label = chartData.labels[labelIndex];

        participants[label] = {};
        for(const data of chartData.data) {
            participants[label][data.label] = data.participants[labelIndex];
        }
    }

    return participants;
}

const chartOptions = participants => ({
    title: {
        display: false
    },
    legend: {
        display: false
    },
    tooltips: participants ? {
        enabled: true,
        callbacks: {
            label: function (tooltipItem, data) {
                const label = data.datasets[tooltipItem.datasetIndex].label || '';
                if(label.includes('New Sign Ons')) {
                    return `${label}: ${tooltipItem.value}`;
                }

                const mobilizationType = label.substring(0, label.indexOf('|') - 1);
                const participantCount = participants[tooltipItem.label][mobilizationType];

                return `${mobilizationType} | Total People Engaged: ${participantCount}`;
            }
        }
    } : {},
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
});

const mobilizationParticipants = chartData => {
    const datasets = [];
    const metrics = [];
    let count = 0;

    for(const data of chartData.data) {
        datasets.push({
            label: `${data.label} | New Sign Ons`,
            backgroundColor: colors[count],
            data: data.new,
            minBarLength: 2,
            stack: count });

        const label = `${data.label} | Non-Converted`;

        datasets.push({
            label,
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
        options: chartOptions(getParticipants(chartData))
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
            data: data.total_donation_subscriptions,
            minBarLength: 2,
            stack: count });

        metrics.push(createMetricsDiv(data.label, colors[count], calculateTotalAsMoney(data.total_donation_subscriptions)));
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
        options: chartOptions()
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