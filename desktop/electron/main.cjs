const { app, BrowserWindow } = require('electron');
const { spawn } = require('child_process');
const path = require('path');

let backendProcess;

function resolveBackendLaunchCommand() {
  const scriptName = process.platform === 'win32' ? 'run-backend-win.bat' : 'run-backend-linux.sh';

  if (app.isPackaged) {
    return {
      cmd: path.join(process.resourcesPath, 'backend', scriptName),
      cwd: path.join(process.resourcesPath, 'backend'),
      shell: process.platform === 'win32'
    };
  }

  return {
    cmd: path.resolve(__dirname, '..', '..', 'dist', 'backend', scriptName),
    cwd: path.resolve(__dirname, '..', '..', 'dist', 'backend'),
    shell: process.platform === 'win32'
  };
}

function startBackend() {
  const launch = resolveBackendLaunchCommand();
  backendProcess = spawn(launch.cmd, [], {
    cwd: launch.cwd,
    shell: launch.shell,
    stdio: 'inherit'
  });

  backendProcess.on('exit', (code) => {
    if (code !== 0) {
      console.error(`Backend exited with code ${code}`);
    }
  });
}

function createMainWindow() {
  const mainWindow = new BrowserWindow({
    width: 1366,
    height: 860,
    minWidth: 960,
    minHeight: 640,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.cjs'),
      contextIsolation: true,
      sandbox: true
    }
  });

  if (app.isPackaged) {
    const indexPath = path.join(process.resourcesPath, 'frontend', 'index.html');
    mainWindow.loadFile(indexPath).catch(console.error);
  } else {
    const devUrl = process.env.FILEHUB_UI_DEV_URL || 'http://127.0.0.1:5173';
    mainWindow.loadURL(devUrl).catch(console.error);
  }
}

app.whenReady().then(() => {
  startBackend();
  createMainWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createMainWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (backendProcess && !backendProcess.killed) {
    backendProcess.kill('SIGTERM');
  }
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
