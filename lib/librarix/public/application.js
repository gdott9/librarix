function initButtons() {
  var buttons = document.querySelectorAll('button[data-action=remove-movie]');
  for (var i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener('click', function(event) {
      event.preventDefault();
      removeMovie(this.previousElementSibling.value)
    });
  }

  var view_buttons = document.querySelectorAll('button[data-action=view-movie]');
  for (var i = 0; i < view_buttons.length; i++) {
    view_buttons[i].addEventListener('click', function(event) {
      event.preventDefault();
      viewMovie(this.previousElementSibling.value)
    });
  }
}

function initSearch() {
  var typing_timer;
  var typing_interval = 300;

  document.querySelector('#search > input[type="text"]').addEventListener('input', function(event) {
    var value = this.value;

    clearTimeout(typing_timer);
    typing_timer = setTimeout(function() { search(value); }, typing_interval);
  });
  document.querySelector('#search > input[type="submit"]').style.display = 'none';

  window.addEventListener('popstate', function(event) {
    document.querySelector('#search > input[type="text"]').value = event.state.value;
    search(event.state.value);
  });
}

function search(value) {
  var url = '/search?search=' + encodeURIComponent(value)
  window.history.pushState({value: value}, "", url);

  var req = new XMLHttpRequest();
  req.open('GET', url);
  req.setRequestHeader("X-Requested-With", "XMLHttpRequest");

  req.addEventListener('load', function(e) {
    document.getElementById('movies').parentNode.innerHTML = this.responseText;
  });

  req.send()
}

function removeMovie(id) {
  var data = new FormData();
  data.append('id', id);

  var req = new XMLHttpRequest();
  req.open('POST', '/remove');
  req.setRequestHeader("X-Requested-With", "XMLHttpRequest");

  req.addEventListener('load', function(e) {
    document.querySelector('.movie[data-id="' + id + '"]').parentNode.remove();
  });

  req.send(data)
}

function viewMovie(id) {
  var data = new FormData();
  data.append('id', id);

  var req = new XMLHttpRequest();
  req.open('POST', '/view');
  req.setRequestHeader("X-Requested-With", "XMLHttpRequest");

  req.addEventListener('load', function(e) {
    document.querySelector('.movie[data-id="' + id + '"] button[data-action="view-movie"]').parentNode.remove();
  });

  req.send(data)
}

document.addEventListener('DOMContentLoaded', function(event) {
  initButtons();

  if(document.querySelector('#search') != null) {
    initSearch();
  }
});
