# ISLAND: LOST

Jogo 3D de sobrevivência para Android, desenvolvido com Godot 4.3.

## Compilação Android

O workflow **Build Android APK** em GitHub Actions compila o APK para ARM64.

Para iniciar a compilação, coloque o arquivo `IslandLost_Godot_v2.zip` na raiz deste repositório. O ZIP deve conter a pasta `island-lost-godot/` com `project.godot`, `export_presets.cfg`, `scenes/` e `scripts/`.

Depois, abra a aba **Actions** para acompanhar a compilação. O APK será publicado como artefato e em uma pré-release quando o build terminar com sucesso.

> O primeiro APK ainda precisa passar pela compilação e por testes no aparelho. Não há build validado neste momento.
