var apiKey = "AIzaSyDUbWRtQWZ3pC8radEZuKVryQ8A2dlayQw";

fetchSearchResults($(".congress-number").val());

$(".congress-number").change(function() {
  $(".bills-container").empty();
  fetchRecentBills($(this).val());
});

function fetchRecentBills(congressNumber) {
  superagent
    .get(
      'https://api.propublica.org/congress/v1/members/G000359/bills/introduced.json'
    )
    .set("X-API-Key", apiKey)
    .then(function(response) {
      renderBills(response.body.results[0].bills);
    });
}

function renderBills(bills) {
  bills.forEach(function(bill) {
    $(".bills-container").append(`
      <div class="bill">
        <h2>${bill.title}</h2>
        <h3>Sponsored by 
        ${bill.sponsor_title} 
        ${bill.sponsor_name} 
        (${bill.sponsor_party} - ${bill.sponsor_state})</h3>
        <p>${bill.summary}</h2>
      </div>
    `);
  });
}
