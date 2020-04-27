const stripHash = hash => hash ? hash.substring(1) : '';

const setDateRange = (start, end) => {
    document.getElementById('report-page-start-date').textContent = start;
    document.getElementById('report-page-end-date').textContent = end;
}

const setFilterDayCount = num => document.getElementById('filter-day-count').textContent = num;

const setActiveFilter = ele => {
    for(const filterLink of document.getElementsByClassName('nav-link')) {
        filterLink.classList.remove('active');
    }

    ele.classList.add('active');
}

const setURLHash = (hash) => {
    location.hash = hash;
};

const getReportsTilesData = (dateRange) => {
    $.ajax({
        url: '/reports/tiles',
        type: 'get',
        data: {dateRange}
    }).done(data => {
        $('#members').html(data.members);
        $('#chapters').html(data.chapters);
        $('#actions').html(data.actions);
        $('#trainings').html(data.trainings);
        setDateRange(data.start_date, data.end_date);
    });
}

const onHashChange = () => {
    const hash = location.hash ? stripHash(location.hash) : 'week';
    getReportsTilesData(hash);

    setActiveFilter(document.getElementById(`filter-${hash}`));

    switch (hash) {
        case "week":
            setFilterDayCount(7);
            break;
        case "month":
            setFilterDayCount(30);
            break;
        case "quarter":
            setFilterDayCount(90);
            break;
        case "half-year":
            setFilterDayCount(180);
            break;
    }
};

const registerFilterClickHandlers = () => {
    document.getElementById('filter-week')
        .addEventListener('click', () => setURLHash('week'));
    document.getElementById('filter-month')
        .addEventListener('click', () => setURLHash('month'));
    document.getElementById('filter-quarter')
        .addEventListener('click', () => setURLHash('quarter'));
    document.getElementById('filter-half-year')
        .addEventListener('click', () => setURLHash('half-year'));
}

const initChart = () => {
    var myChart = new Chart(
        document.getElementById('chart').getContext('2d'),
        {
            type: 'bar',
            data: {
                labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                datasets: [{
                    label: '# of Votes',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
    console.log(myChart);
};


export default () => {
    window.addEventListener("hashchange", onHashChange, false);
    onHashChange();

    registerFilterClickHandlers();

    initChart();
};