function request(method, url, data, loadevent) {
  var req = new XMLHttpRequest();
  req.open(method, url);
  req.setRequestHeader("X-Requested-With", "XMLHttpRequest");

  req.addEventListener('load', loadevent);

  req.send(data)
}

function init() {
  var movies = document.querySelectorAll('.movie');
  for (var i = 0; i < movies.length; i++) {
    new Movie(movies[i].dataset.id);
  }
}

var Movie = function(id) {
  this.id = parseInt(id);
  this.element = document.querySelector('.movie[data-id="'+id+'"]');

  var remove_button = this.element.querySelector('button[data-action="remove-movie"]');
  var update_button = this.element.querySelector('button[data-action="update-movie"]');
  var view_button = this.element.querySelector('button[data-action="view-movie"]');

  if (remove_button) {
    remove_button.addEventListener('click', function(e) {
      e.preventDefault();
      this.remove();
    }.bind(this));
  }

  if (update_button) {
    update_button.addEventListener('click', function(e) {
      e.preventDefault();
      this.update();
    }.bind(this));
  }

  if (view_button) {
    view_button.addEventListener('click', function(e) {
      e.preventDefault();
      this.view();
    }.bind(this));
  }

  this.formData = function() {
    var data = new FormData();
    data.append('id', this.id);

    return data;
  }

  this.update = function() {
    request('POST', '/update', this.formData(), function(e) {
      oldelem = this.element;

      tmp_elem = document.createElement('div');
      tmp_elem.innerHTML = e.target.response;

      this.element = tmp_elem.firstChild;

      oldelem.parentNode.replaceChild(this.element, oldelem);
    }.bind(this));
  };

  this.remove = function() {
    request('POST', '/remove', this.formData(), function(e) {
      this.element.parentNode.remove();
    }.bind(this));
  };

  this.view = function() {
    request('POST', '/view', this.formData(), function(e) {
      this.element.querySelector('button[data-action="view-movie"]').parentNode.remove();
    }.bind(this));
  };
};

document.addEventListener('DOMContentLoaded', function(event) {
  init();
});
