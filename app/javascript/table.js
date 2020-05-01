let country, state, region, chapter, groupByProperty, groupByLabel, queryParams;
let xhr;
let data = {};
const stripHash = hash => hash ? hash.substring(1) : '';

function init() {
    getContext();
    setGroupByHeaderLabel();
    makeTableSortable();
}

function updateTable() {
    if (xhr) xhr.abort(); //abort outstanding requests
    getContext();
    xhr = $.getJSON('/reports/table', queryParams);
    xhr.done((result) => {
        if (Object.keys(result).length > 1) {
            data = result.sort((x, y) => y.members - x.members);
            renderTableBody(result);
        } else {
            renderTableBody(result);
        }
    });
    xhr.always(() => {
        xhr = undefined;//clear request
    });
}

function getContext() {
    let currentUrl = new URL(window.location.href);
    let params = currentUrl.searchParams;
    country = params.get('country');
    state = params.get('state');
    region = params.get('region');
    chapter = params.get('chapter');

    groupByProperty = 'country';
    groupByLabel = 'Countries';
    queryParams = {};
    if (country) {
        queryParams.country = country;
        if (country.toUpperCase() === 'US') {
            groupByProperty = 'region';
            groupByLabel = 'Regions';
        } else {
            groupByProperty = 'state';
            groupByLabel = 'States';
        }
    }

    if (region) {
        queryParams.region = region;
        groupByProperty = 'state';
        groupByLabel = 'States';
    }

    if (state) {
        queryParams.state = state;
        groupByProperty = 'chapter';
        groupByLabel = 'Chapters';

    }
    if (chapter) {
        queryParams.chapter = chapter;
        groupByProperty = 'chapter';
        groupByLabel = 'Chapter';
    }

    queryParams.period = location.hash ? stripHash(location.hash) : 'week';
}


function setGroupByHeaderLabel() {
    let groupByColHeader = $("table.report-table thead tr th").first();
    groupByColHeader.text(groupByLabel);
    groupByColHeader.attr('xr-table-key', groupByProperty);
    groupByColHeader.append('<i class="fa fa-sort"></i>')
}

function makeTableSortable() {
    let tableHead = $("table.report-table thead");
    tableHead.find("tr th").click(function () {
        let orderAsc = $(this).attr("asc");
        if (orderAsc) {
            $(this).removeAttr("asc");
            orderAsc = false;
        } else {
            $(this).attr("asc", "true");
            orderAsc = true;
        }
        sortBy($(this).attr("xr-table-key"), orderAsc);
    });
}

const sortString = (x, y, asc) => asc ? ("" + x).localeCompare(y) : ("" + y).localeCompare(x);
const sortNumber = (x, y, asc) => asc ? x - y : y - x;

function sortBy(columnName, asc) {
    let sort = isNaN(data[0][columnName]) ? sortString : sortNumber;
    let order = (x, y) => {
        return sort(x[columnName], y[columnName], asc);
    };
    data = data.sort(order);
    renderTableBody(data);
}

const record = (obj) => {
    let link = `/reports?`;
    let queryParams = [];

    if (country) queryParams.push(`country=${country}`);
    if (region) queryParams.push(`region=${region}`);
    if (state) queryParams.push(`state=${state}`);
    if (chapter) queryParams.push(`chapter=${chapter}`);
    queryParams.push(`${groupByProperty}=${obj.id}`)

    link += queryParams.join('&') + location.hash;
    link = encodeURI(link);

    return `<tr>
              <td scope="row"><a href=${link}>${obj[groupByProperty]}</a></td>
              <td>${obj.chapters === null ? 0 : obj.chapters}</td>
              <td>${obj.members === null ? 0 : obj.members}</td>
              <td>${obj.mobilizations === null ? 0 : obj.mobilizations}</td>
              <td>${obj.trainings === null ? 0 : obj.trainings}</td>
              <td>${obj.subscriptions === null ? 0 : obj.subscriptions}</td>
              <td>${obj.signups === null ? 0 : obj.signups}</td>
              <td>${obj.arrestable_pledges === null ? 0 : obj.arrestable_pledges}</td>
              <td>${obj.actions === null ? 0 : obj.actions}</td>
            </tr>`
};

function renderTableBody(data) {
    const tableBody = $("table.report-table tbody");
    tableBody.empty();
    $.each(data, function (i, v) {
        tableBody.append(record(v));
    });
}


const table = {
    init: init,
    updateTable: updateTable
};

export default table;