# <img src="https://raw.githubusercontent.com/DaviGayDaSilva/Brokess-Live/main/assets/images/bkl-logo.png" width="64" height="64"/> Brokess Live (BKL)

<div align="center">

![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Linux%20%7C-Windows-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-GPL--3.0-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-orange?style=for-the-badge)
![Dart](https://img.shields.io/badge/Dart-3.4-blue?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.41-blue?style=for-the-badge)

</div>

## 🇧🇷 Português

### O que é o Brokess Live?

**Brokess Live (BKL)** é um software de streaming e gravação de vídeo gratuito e de código aberto, desenvolvido especificamente para dispositivos móveis. Assim como o OBS Studio, oferece recursos profissionais de transmissão ao vivo, mas com uma interface otimizada para smartphones e tablets.

### ✨ Recursos Principais

- 📹 **Streaming ao Vivo** - Transmita para servidores RTMP (Twitch, YouTube, Facebook, etc.)
- 🎥 **Múltiplas Fontes de Câmera** - Câmera frontal, traseira, múltiplas câmeras
- 🎬 **Gerenciamento de Cenas** - Crie e organize cenas com múltiplas fontes
- 🌐 **Overlays Web** - Suporte a overlays via navegador interno
- 🔤 **Fontes Integradas** - Imagem, vídeo, texto, cor sólida, navegador
- 🎛️ **Mixer de Áudio** - Controle total sobre fontes de áudio
- 🎨 **Temas Escuro e Claro** - Interface adaptativa
- 🚫 **Sem Anúncios** - Totalmente gratuito, sem propagandas
- 🔓 **Código Aberto** - Contribua e personalize como quiser

### 📱 Plataformas Suportadas

| Plataforma | Status | Instalador |
|------------|--------|------------|
| Android | ✅ Disponível | [.apk](./releases) |
| Linux | ✅ Disponível | [.deb](./releases) |
| Windows | 🔄 Em breve | - |

### 🚀 Como Instalar

#### Android

1. Baixe o arquivo `.apk` da aba [Releases](https://github.com/DaviGayDaSilva/Brokess-Live/releases)
2. Permita instalação de fontes desconhecidas nas configurações
3. Instale e aprove!

#### Linux (Debian/Ubuntu)

```bash
sudo dpkg -i brokess-live_1.0.0_amd64.deb
sudo apt-get install -f  # Instalar dependências
```

### 💻 Desenvolvimento

#### Pré-requisitos

- Flutter SDK 3.41+
- Android SDK 34+
- Java JDK 21+

#### Executando o Projeto

```bash
# Clonar o repositório
git clone https://github.com/DaviGayDaSilva/Brokess-Live.git
cd Brokess-Live

# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Build APK
flutter build apk --debug

# Build Release APK
flutter build apk --release

# Build Linux
flutter build linux --release
```

### 📂 Estrutura do Projeto

```
lib/
├── core/                    # Configurações e utilitários centrais
│   ├── constants/          # Constantes da aplicação
│   ├── entities/           # Entidades de domínio
│   ├── theme/              # Temas (escuro/claro)
│   └── widgets/            # Widgets compartilhados
├── features/               # Funcionalidades do app
│   ├── live/              # Tela de transmissão ao vivo
│   ├── scenes/            # Gerenciamento de cenas
│   ├── settings/          # Configurações
│   └── stream/            # Stream e estatísticas
└── main.dart              # Ponto de entrada
```

### 🤝 Contribuindo

1. Fork o projeto
2. Crie sua branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'feat: nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

### 📄 Licença

Este projeto está licenciado sob a **GNU General Public License v3.0** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### 🙏 Agradecimentos

- [OBS Project](https://obsproject.com/) - Inspiração e referência
- [Flutter](https://flutter.dev/) - Framework incrível
- [flutter_webrtc](https://pub.dev/packages/flutter_webrtc) - Streaming WebRTC
- [camera](https://pub.dev/packages/camera) - API de câmera

---

## 🇺🇸 English

### What is Brokess Live?

**Brokess Live (BKL)** is free and open source video recording and streaming software, developed specifically for mobile devices. Like OBS Studio, it offers professional live broadcasting features, but with an interface optimized for smartphones and tablets.

### Key Features

- 📹 **Live Streaming** - Stream to RTMP servers (Twitch, YouTube, Facebook, etc.)
- 🎥 **Multiple Camera Sources** - Front, back, multiple cameras
- 🎬 **Scene Management** - Create and organize scenes with multiple sources
- 🌐 **Web Overlays** - Support for overlays via internal browser
- 🔤 **Built-in Sources** - Image, video, text, solid color, browser
- 🎛️ **Audio Mixer** - Full control over audio sources
- 🎨 **Dark/Light Themes** - Adaptive interface
- 🚫 **No Ads** - Completely free, no advertisements
- 🔕 **Open Source** - Contribute and customize as you wish

### Supported Platforms

| Platform | Status | Installer |
|----------|--------|-----------|
| Android | ✅ Available | [.apk](./releases) |
| Linux | ✅ Available | [.deb](./releases) |
| Windows | 🔄 Coming Soon | - |

### How to Install

#### Android

1. Download the `.apk` file from the [Releases](https://github.com/DaviGayDaSilva/Brokess-Live/releases) tab
2. Allow installation from unknown sources in settings
3. Install and enjoy!

#### Linux (Debian/Ubuntu)

```bash
sudo dpkg -i brokess-live_1.0.0_amd64.deb
sudo apt-get install -f  # Install dependencies
```

### Development

#### Prerequisites

- Flutter SDK 3.41+
- Android SDK 34+
- Java JDK 21+

#### Running the Project

```bash
# Clone the repository
git clone https://github.com/DaviGayDaSilva/Brokess-Live.git
cd Brokess-Live

# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build APK
flutter build apk --debug

# Build Release APK
flutter build apk --release

# Build Linux
flutter build linux --release
```

### Contributing

1. Fork the project
2. Create your branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'feat: new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

### License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

### Acknowledgments

- [OBS Project](https://obsproject.com/) - Inspiration and reference
- [Flutter](https://flutter.dev/) - Amazing framework
- [flutter_webrtc](https://pub.dev/packages/flutter_webrtc) - WebRTC streaming
- [camera](https://pub.dev/packages/camera) - Camera API

---

<div align="center">

**Feito com ❤️ pela Brokess Team**

**Made with ❤️ by Brokess Team**

</div>
