<p align="center">
  <img src="flutter/assets/icon.png" alt="ImperoDesk" width="128"><br>
  <b>ImperoDesk</b> — desktop remoto open source per Windows
</p>

## Download

Scarica l'ultima versione dalla pagina [Releases](../../releases):

- **ImperoDesk-install.exe** — doppio clic per installare ImperoDesk sul PC
- **ImperoDesk.exe** — versione portable, si avvia senza installazione

Questa versione **non si aggiorna automaticamente**.

> L'exe non è firmato digitalmente: se Windows SmartScreen mostra "Editore sconosciuto",
> clicca su "Altre informazioni" → "Esegui comunque".

## Funzionalità

- Controllo remoto del desktop con ID e password
- Trasferimento file, chat, appunti condivisi
- Codifica video hardware (NVIDIA / AMD / Intel) quando disponibile
- Crittografia end-to-end

## Compilare da sorgente (Windows x64)

Requisiti: Git, Visual Studio 2022 Build Tools (C++), Rust 1.75, LLVM 15.0.6,
Flutter 3.24.5 in `C:\dev\flutter`, vcpkg in `C:\dev\vcpkg`.

```powershell
# librerie native (una volta sola)
$env:VCPKG_ROOT = "C:\dev\vcpkg"
C:\dev\vcpkg\vcpkg.exe install --triplet x64-windows-static --x-install-root="C:\dev\vcpkg\installed"

# bridge Rust <-> Flutter (una volta sola, e dopo modifiche a src/flutter_ffi.rs)
cargo install flutter_rust_bridge_codegen --version 1.80.1 --features "uuid" --locked
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart

# build completa -> dist\ImperoDesk.exe
powershell -ExecutionPolicy Bypass -File .\build-imperodesk.ps1
```

## Licenza

ImperoDesk è software libero distribuito con licenza **GNU AGPL-3.0** (vedi [LICENCE](LICENCE)).
È basato sul codice open source di [RustDesk](https://github.com/rustdesk/rustdesk),
© Purslane Tech Pte. Ltd., anch'esso AGPL-3.0.
