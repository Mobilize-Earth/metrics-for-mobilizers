import Chart from 'chart.js';

const randomNumberForTesting = () => Math.floor(Math.random() * Math.floor(10));
const randomNumberArrayForTesting = () => [ randomNumberForTesting(), randomNumberForTesting(), randomNumberForTesting(), randomNumberForTesting(), randomNumberForTesting(), randomNumberForTesting(), randomNumberForTesting() ];

export default {
    initChart: () => new Chart('chart',{
        type: 'bar',
        data: {
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
            datasets: [
                {
                    label: 'H4E Presentations / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 0
                }, {
                    label: 'H4E Presentations / Existing Members',
                    backgroundColor: '#fc577a',
                    data: randomNumberArrayForTesting(),
                    stack: 0
                }, {
                    label: 'Rebel Ringing / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 1
                }, {
                    label: 'Rebel Ringing / Existing Members',
                    backgroundColor: '#ffd04c',
                    data: randomNumberArrayForTesting(),
                    stack: 1
                }, {
                    label: 'House Meetings / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 2
                }, {
                    label: 'House Meetings / Existing Members',
                    backgroundColor: '#66a4fb',
                    data: randomNumberArrayForTesting(),
                    stack: 2
                }, {
                    label: 'Fly Posting / Chalking / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 3
                }, {
                    label: 'Fly Posting / Chalking / Existing Members',
                    backgroundColor: '#62dcde',
                    data: randomNumberArrayForTesting(),
                    stack: 3
                }, {
                    label: 'Door Knocking / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 4
                }, {
                    label: 'Door Knocking / Existing Members',
                    backgroundColor: '#f2b8ff',
                    data: randomNumberArrayForTesting(),
                    stack: 4
                }, {
                    label: 'Street Stalls / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 5
                }, {
                    label: 'Street Stalls / Existing Members',
                    backgroundColor: '#ff6db0',
                    data: randomNumberArrayForTesting(),
                    stack: 5
                }, {
                    label: 'Leafleting / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 6
                }, {
                    label: 'Leafleting / Existing Members',
                    backgroundColor: '#a5d7fd',
                    data: randomNumberArrayForTesting(),
                    stack: 6
                }, {
                    label: '1:1 Recruiting / Other / New Members',
                    backgroundColor: '#666',
                    data: randomNumberArrayForTesting(),
                    stack: 7
                }, {
                    label: '1:1 Recruiting / Other / Existing Members',
                    backgroundColor: '#f15946',
                    data: randomNumberArrayForTesting(),
                    stack: 7
                }
            ]
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
            responsive: true,
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
};