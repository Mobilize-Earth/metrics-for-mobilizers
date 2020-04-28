let country, state, region, groupByProperty, groupByLabel, queryParams;
let data = {};

function init(){
    getContext();
    setGroupByHeaderLabel();
    makeTableSortable();
}

function updateTable() {
    $.getJSON('/reports/table', queryParams, function (result) {
        data = result.sort((x, y) => y.members - x.members);
        renderTableBody(result);
    });
}

function getContext() {
    let currentUrl = new URL(window.location.href);
    let params = currentUrl.searchParams;
    country = params.get('country');
    state = params.get('state');
    region = params.get('region');

    groupByProperty = 'country';
    groupByLabel = 'Countries';
    queryParams = {};
    if (country) {
        queryParams.country = country;
        if(country.toUpperCase()==='US'){
            groupByProperty = 'region';
            groupByLabel = 'Regions';
        } else{
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
    queryParams.push(`${groupByProperty}=${obj.id}`)

    link += queryParams.join('&') + location.hash;

    if (state) link = `/chapters/${obj.id}`;

    return `<tr>
              <td scope="row"><a href=${link}>${obj[groupByProperty]}</a></td>
              <td>${obj.chapters}</td>
              <td>${obj.members}</td>
              <td>${obj.mobilizations}</td>
              <td>${obj.trainings}</td>
              <td>${obj.subscriptions}</td>
              <td>${obj.signups}</td>
              <td>${obj.arrestable_pledges}</td>
              <td>${obj.actions}</td>
            </tr>`
};

function renderTableBody(data) {
    const tableBody = $("table.report-table tbody");
    tableBody.empty();
    $.each(data, function (i, v) {
        tableBody.append(record(v));
    });
}


export default {
    init:init,
    updateTable: updateTable
};