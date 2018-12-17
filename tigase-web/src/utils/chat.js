import {
  Strophe
} from "strophe.js";

console.log(Strophe);


class Chat {

  constructor() {
    this._conn = new Strophe.Connection('/api/chat');
    this._conn.addHandler(msg => {
      // console.log(msg);
      const m = {};
      m.from = msg.getAttribute('from');
      m.to = msg.getAttribute('to');
      m.type = msg.getAttribute('type');
      const elems = msg.getElementsByTagName('body');
      m.body = [];
      for (const elem of elems) {
        m.body.push(Strophe.getText(elem));
      }
      this.fire('message', m);
      return true;
    }, null, 'message', null, null, null);
    this._conn.xmlInput = msg => {
      console.log(msg);
    }
  }

  on(e, callback) {
    if (Array.isArray(e)) {
      for (const e1 in e) {
        this.on(e1, callback);
      }
      return this;
    }
    e = e.toLowerCase();
    const events = this._events = this._events || {};
    const callBacks = events[e] = events[e] || [];
    callBacks.push(callback);
    return this;
  }

  once(e, callback) {
    if (Array.isArray(e)) {
      for (const e1 in e) {
        this.once(e1, callback);
      }
      return;
    }
    e = e.toLowerCase();
    const events = this._onceEvents = this._onceEvents || {};
    const callBacks = events[e] = events[e] || [];
    callBacks.push(callback);
    return this;
  }

  fire(e) {
    e = e.toLowerCase();
    console.log('事件', e);
    const events = this._events = this._events || {};
    const callBacks = events[e];
    const args = [];
    for (let i = 1; i < arguments.length; i++) {
      args.push(arguments[i]);
    }
    if (callBacks && callBacks.length > 0) {
      for (const callback of callBacks) {
        callback.apply(this, args);
      }
    }
    const onceEvents = this._onceEvents = this._onceEvents || {};
    const onceCallBacks = onceEvents[e];
    if (onceCallBacks && onceCallBacks.length > 0) {
      for (let i = 0; i > onceCallBacks.length; i++) {
        onceCallBacks[i].apply(this, args);
        onceCallBacks.split(i, 1);
      }
    }
    return this;
  }

  connect(userName, password) {
    this._conn.connect(userName, password, status => {
      for (const st in Strophe.Status) {
        if (Strophe.Status[st] == status) {
          if (st == 'CONNECTED') {
            this._send($pres().tree());
          }
          this.fire(st);
          return;
        }
      }
    });
    return this;
  }

  _send(msg) {
    this._conn.send(msg);
  }

  send(toJid, msg) {
    if (!toJid || !msg) {
      return this;
    }
    this._send($msg({
      to: toJid,
      type: /muc/.test(toJid) ? 'groupchat' : 'chat'
    }).c('body', null, msg).tree());
    return this;
  }

  joinRoom(roomId) {
    const jid = this._conn.jid;
    this._send($pres({
        // from: jid,
        to: roomId + "/" + jid.substring(0, jid.indexOf("@"))
        // to: roomId
      })
      .c('x', {
        xmlns: 'http://jabber.org/protocol/muc'
      })
      .tree());
  }

}

export default Chat;