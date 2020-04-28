import Charts from './charts';
import reportTable from './table';

const stripHash = hash => hash ? hash.substring(1) : '';

const setDateRange = (start, end) => {
    for (const ele of document.getElementsByClassName('report-page-start-date')) {
        ele.textContent = start;
    }
    for (const ele of document.getElementsByClassName('report-page-end-date')) {
        ele.textContent = end;
    }
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
        $('#mobilizations').html(data.mobilizations);
        $('#pledges-arrestable').html(data.pledges_arrestable);
        $('#subscriptions').html(data.subscriptions);
        setDateRange(data.start_date, data.end_date);
    });
}

const getReportsChartsData = (dateRange) => {
    $.ajax({
        url: '/reports/charts/mobilizations',
        type: 'get',
        data: {dateRange}
    }).done(data => {
        console.log({data, e: 'loaded'});

        Charts.initChart(data);
    });
}

const onHashChange = () => {
    const hash = location.hash ? stripHash(location.hash) : 'week';
    getReportsTilesData(hash);
    getReportsChartsData(hash);

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

export default () => {
    window.addEventListener("hashchange", onHashChange, false);
    window.addEventListener("hashchange", reportTable.updateTable, false);
    onHashChange();
    reportTable.init();
    reportTable.updateTable();

    registerFilterClickHandlers();
};