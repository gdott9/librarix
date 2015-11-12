function request(method, url, data, loadevent) {
  var req = new XMLHttpRequest();
  req.open(method, url);
  req.setRequestHeader("X-Requested-With", "XMLHttpRequest");

  req.addEventListener('load', loadevent);

  req.send(data)
}

function initButtons(element) {
  var buttons = element.querySelectorAll('button[data-action=remove-movie]');
  for (var i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener('click', function(event) {
      event.preventDefault();
      removeMovie(this.previousElementSibling.value)
    });
  }

  var view_buttons = element.querySelectorAll('button[data-action=view-movie]');
  for (var i = 0; i < view_buttons.length; i++) {
    view_buttons[i].addEventListener('click', function(event) {
      event.preventDefault();
      viewMovie(this.previousElementSibling.value)
    });
  }
}

function removeMovie(id) {
  var data = new FormData();
  data.append('id', id);

  request('POST', '/remove', data, function(e) {
    document.querySelector('.movie[data-id="' + id + '"]').parentNode.remove();
  });
}

function viewMovie(id) {
  var data = new FormData();
  data.append('id', id);

  request('POST', '/view', data, function(e) {
    document.querySelector('.movie[data-id="' + id + '"] button[data-action="view-movie"]').parentNode.remove();
  });
}

document.addEventListener('DOMContentLoaded', function(event) {
  initButtons(document);
});
