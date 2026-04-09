const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('filehubDesktop', {
  version: '0.1.0'
});
