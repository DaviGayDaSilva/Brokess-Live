import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../stream/presentation/providers/stream_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            _buildAppHeader(),
            const SizedBox(height: 20),

            // Stream Settings Section
            _buildSectionTitle('Stream'),
            _buildStreamSettings(context, ref),
            const SizedBox(height: 20),

            // Video Settings Section
            _buildSectionTitle('Vídeo'),
            _buildVideoSettings(context, ref),
            const SizedBox(height: 20),

            // Audio Settings Section
            _buildSectionTitle('Áudio'),
            _buildAudioSettings(context, ref),
            const SizedBox(height: 20),

            // Overlay Settings
            _buildSectionTitle('Overlays'),
            _buildOverlaySettings(context, ref),
            const SizedBox(height: 20),

            // Appearance Section
            _buildSectionTitle('Aparência'),
            _buildAppearanceSettings(context, ref, settings),
            const SizedBox(height: 20),

            // Advanced Section
            _buildSectionTitle('Avançado'),
            _buildAdvancedSettings(context, ref, settings),
            const SizedBox(height: 20),

            // About Section
            _buildSectionTitle('Sobre'),
            _buildAboutSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.live_tv,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Brokess Live',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildStreamSettings(BuildContext context, WidgetRef ref) {
    final streamSettings = ref.watch(streamSettingsProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.link, color: AppTheme.primaryColor),
            title: const Text('URL do Servidor'),
            subtitle: Text(
              streamSettings.rtmpUrl.isNotEmpty
                  ? streamSettings.rtmpUrl
                  : 'Não configurado',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showRtmpDialog(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.key, color: AppTheme.primaryColor),
            title: const Text('Chave de Stream'),
            subtitle: Text(
              streamSettings.streamKey.isNotEmpty
                  ? '••••••••••••••••'
                  : 'Não configurado',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showStreamKeyDialog(context, ref),
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.fiber_manual_record, color: AppTheme.primaryColor),
            title: const Text('Gravar Localmente'),
            value: streamSettings.recordLocal,
            onChanged: (value) {
              ref.read(streamProvider.notifier).updateSettings(
                    streamSettings.copyWith(recordLocal: value),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSettings(BuildContext context, WidgetRef ref) {
    final streamSettings = ref.watch(streamSettingsProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.aspect_ratio, color: AppTheme.primaryColor),
            title: const Text('Resolução'),
            subtitle: Text(
              '${streamSettings.videoWidth} x ${streamSettings.videoHeight}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showResolutionDialog(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.videocam, color: AppTheme.primaryColor),
            title: const Text('FPS'),
            subtitle: Text(
              '${streamSettings.frameRate}',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFpsDialog(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.speed, color: AppTheme.primaryColor),
            title: const Text('Taxa de Bits'),
            subtitle: Text(
              '${streamSettings.videoBitrate} kbps',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showBitrateDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSettings(BuildContext context, WidgetRef ref) {
    final streamSettings = ref.watch(streamSettingsProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.mic, color: AppTheme.primaryColor),
            title: const Text('Microfone'),
            subtitle: const Text(
              'Padrão do sistema',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.hearing, color: AppTheme.primaryColor),
            title: const Text('Bitrate de Áudio'),
            subtitle: Text(
              '${streamSettings.audioBitrate} kbps',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAudioBitrateDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlaySettings(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.web, color: AppTheme.primaryColor),
            title: const Text('Overlay Web'),
            subtitle: const Text(
              'URL externa para overlay',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showWebOverlayDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.widgets, color: AppTheme.primaryColor),
            title: const Text('Overlay Interno'),
            subtitle: const Text(
              'Gerenciar overlays internos',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showInternalOverlayDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings(BuildContext context, WidgetRef ref, AppSettings settings) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode, color: AppTheme.primaryColor),
            title: const Text('Tema'),
            subtitle: Text(
              settings.themeMode == AppThemeMode.dark
                  ? 'Escuro'
                  : settings.themeMode == AppThemeMode.light
                      ? 'Claro'
                      : 'Sistema',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref, settings),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language, color: AppTheme.primaryColor),
            title: const Text('Idioma'),
            subtitle: Text(
              settings.language == 'pt' ? 'Português' : 'English',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, settings),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context, WidgetRef ref, AppSettings settings) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.memory, color: AppTheme.primaryColor),
            title: const Text('Hardware Encoding'),
            subtitle: const Text(
              'Usar codificação de hardware',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            value: settings.enableHardwareEncoding,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setEnableHardwareEncoding(value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.sync, color: AppTheme.primaryColor),
            title: const Text('Reconexão Automática'),
            value: settings.autoReconnect,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setAutoReconnect(value);
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.vibration, color: AppTheme.primaryColor),
            title: const Text('Feedback Háptico'),
            value: settings.hapticFeedback,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setHapticFeedback(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
            title: const Text('Sobre o App'),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.code, color: AppTheme.primaryColor),
            title: const Text('Código Fonte'),
            subtitle: const Text(
              'GitHub',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description, color: AppTheme.primaryColor),
            title: const Text('Licença'),
            subtitle: const Text(
              'MIT License',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showRtmpDialog(BuildContext context, WidgetRef ref) {
    final streamSettings = ref.read(streamSettingsProvider);
    final controller = TextEditingController(text: streamSettings.rtmpUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('URL do Servidor RTMP'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'rtmp://live.twitch.tv/app',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(streamProvider.notifier).updateSettings(
                    streamSettings.copyWith(rtmpUrl: controller.text),
                  );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showStreamKeyDialog(BuildContext context, WidgetRef ref) {
    final streamSettings = ref.read(streamSettingsProvider);
    final controller = TextEditingController(text: streamSettings.streamKey);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chave de Stream'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Sua chave de stream',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(streamProvider.notifier).updateSettings(
                    streamSettings.copyWith(streamKey: controller.text),
                  );
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showResolutionDialog(BuildContext context, WidgetRef ref) {
    final resolutions = [
      {'label': '480p (854 x 480)', 'width': 854, 'height': 480},
      {'label': '720p (1280 x 720)', 'width': 1280, 'height': 720},
      {'label': '1080p (1920 x 1080)', 'width': 1920, 'height': 1080},
    ];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Resolução'),
        children: resolutions.map((res) {
          return SimpleDialogOption(
            onPressed: () {
              final settings = ref.read(streamSettingsProvider);
              ref.read(streamProvider.notifier).updateSettings(
                    settings.copyWith(
                      videoWidth: res['width'] as int,
                      videoHeight: res['height'] as int,
                    ),
                  );
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(res['label'] as String),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFpsDialog(BuildContext context, WidgetRef ref) {
    final fpsOptions = [24, 30, 60];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('FPS'),
        children: fpsOptions.map((fps) {
          return SimpleDialogOption(
            onPressed: () {
              final settings = ref.read(streamSettingsProvider);
              ref.read(streamProvider.notifier).updateSettings(
                    settings.copyWith(frameRate: fps),
                  );
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('$fps fps'),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showBitrateDialog(BuildContext context, WidgetRef ref) {
    final bitrates = [1500, 2500, 4500, 6000, 8000, 10000];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Taxa de Bits (kbps)'),
        children: bitrates.map((bitrate) {
          return SimpleDialogOption(
            onPressed: () {
              final settings = ref.read(streamSettingsProvider);
              ref.read(streamProvider.notifier).updateSettings(
                    settings.copyWith(videoBitrate: bitrate),
                  );
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('$bitrate kbps'),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAudioBitrateDialog(BuildContext context, WidgetRef ref) {
    final bitrates = [64, 96, 128, 192, 256];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Bitrate de Áudio (kbps)'),
        children: bitrates.map((bitrate) {
          return SimpleDialogOption(
            onPressed: () {
              final settings = ref.read(streamSettingsProvider);
              ref.read(streamProvider.notifier).updateSettings(
                    settings.copyWith(audioBitrate: bitrate),
                  );
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('$bitrate kbps'),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showWebOverlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overlay Web'),
        content: const Text(
          'Cole a URL da página que deseja usar como overlay. '
          'A página será renderizada em uma camada sobre o stream.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showInternalOverlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overlay Interno'),
        content: const Text(
          'Gerencie overlays internos como:'
          '\n• Câmera flutuante'
          '\n• Widgets customizados'
          '\n• Frames e bordas',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tema'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setThemeMode(AppThemeMode.dark);
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Escuro'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setThemeMode(AppThemeMode.light);
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Claro'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setThemeMode(AppThemeMode.system);
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Sistema'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Idioma'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setLanguage('en');
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('English'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(settingsProvider.notifier).setLanguage('pt');
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Português'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Brokess Live',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.live_tv, color: Colors.white),
      ),
      children: const [
        Text(
          'Brokess Live (BKL) é um aplicativo de streaming open-source, '
          'gratuito e sem anúncios, projetado para levar a experiência OBS '
          'para dispositivos móveis.',
        ),
        SizedBox(height: 16),
        Text(
          '© 2024 Brokess Live\nLicença: MIT',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
