// Generated by CoffeeScript 2.2.1
(function() {
  var get_mouse_pos, init, on_touch, on_user_mousedown, on_user_mousemove, on_user_mouseup;

  get_mouse_pos = function(evt) {
    var mouse_x, mouse_y;
    mouse_x = evt.clientX - ui.cvs_bounding_rect().left - settings.cvs_border_width;
    mouse_y = evt.clientY - ui.cvs_bounding_rect().top - settings.cvs_border_width;
    return [mouse_x, mouse_y];
  };

  on_user_mousedown = function(evt) {
    var pos;
    pos = get_mouse_pos(evt);
    return ev.trigger('mousedown', {pos});
  };

  on_user_mouseup = function(evt) {
    var pos;
    pos = get_mouse_pos(evt);
    return ev.trigger('mouseup', {pos});
  };

  on_user_mousemove = function(evt) {
    var pos;
    pos = get_mouse_pos(evt);
    return ev.trigger('mousemove', {pos});
  };

  init = function() {
    ui.cvs.animate.addEventListener("mousedown", on_user_mousedown);
    ui.cvs.animate.addEventListener("mouseup", on_user_mouseup);
    ui.cvs.animate.addEventListener("mousemove", on_user_mousemove);
    ui.cvs.animate.addEventListener("touchstart", on_touch);
    ui.cvs.animate.addEventListener("touchmove", on_touch);
    return ui.cvs.animate.addEventListener("touchend", on_touch);
  };

  //ui.cvs.animate.addEventListener "touchcancel", on_touch
  on_touch = function(evt) {
    var first, simulated, touches, type;
    touches = evt.changedTouches;
    first = touches[0];
    type = "";
    switch (evt.type) {
      case "touchstart":
        type = "mousedown";
        break;
      case "touchmove":
        type = "mousemove";
        break;
      case "touchend":
        type = "mouseup";
    }
    // initMouseEvent(type, canBubble, cancelable, view, clickCount, 
    //                screenX, screenY, clientX, clientY, ctrlKey, 
    //                altKey, shiftKey, metaKey, button, relatedTarget);
    simulated = document.createEvent("MouseEvent");
    simulated.initMouseEvent(type, true, true, window, 1, first.screenX, first.screenY, first.clientX, first.clientY, false, false, false, false, 0, null);
    first.target.dispatchEvent(simulated);
    return evt.preventDefault();
  };

  window.input = {init};

}).call(this);

//# sourceMappingURL=input.js.map
