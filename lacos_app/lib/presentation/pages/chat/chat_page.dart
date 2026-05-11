import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(
      text: 'Olá! Sou a assistente do Laço\'s. Aqui você pode fazer perguntas sobre saúde feminina de forma anônima.\n\n'
          'Posso ajudar com dúvidas sobre:\n'
          '• Ciclo menstrual\n'
          '• Corrimento\n'
          '• Cólica e TPM\n'
          '• Exames preventivos\n'
          '• Anticoncepcionais\n'
          '• Menopausa\n'
          '• Autocuidado\n\n'
          'Digite sua pergunta abaixo.',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _controller.clear();
    _scrollToBottom();

    // Resposta educativa automática baseada em palavras-chave
    Future.delayed(const Duration(milliseconds: 800), () {
      final response = _getEducationalResponse(text);
      setState(() {
        _messages.add(_ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getEducationalResponse(String question) {
    final lowerQ = question.toLowerCase();

    if (lowerQ.contains('ciclo') || lowerQ.contains('menstrua')) {
      return 'O ciclo menstrual dura em média 28 dias (podendo variar de 21 a 35 dias). '
          'É normal ter variações. Se seu ciclo estiver muito irregular por mais de 3 meses, '
          'procure uma UBS para avaliação.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('corrimento') || lowerQ.contains('secreção')) {
      return 'O corrimento vaginal transparente ou esbranquiçado, sem cheiro forte, é normal. '
          'Ele varia durante o ciclo. Se notar mudança de cor (amarelo, verde, cinza), '
          'mau cheiro, coceira ou ardência, procure atendimento médico.\n\n'
          'Dicas: use calcinha de algodão, evite duchas vaginais.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('cólica') || lowerQ.contains('dor')) {
      return 'Cólicas leves nos primeiros dias da menstruação são comuns. '
          'Bolsa de água quente, exercícios leves e chás podem ajudar.\n\n'
          'Se a dor for incapacitante ou não melhorar com analgésicos comuns, '
          'procure uma UBS.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('tpm') || lowerQ.contains('humor')) {
      return 'A TPM (Tensão Pré-Menstrual) é causada por variações hormonais e pode causar '
          'irritabilidade, inchaço, sensibilidade e vontade de comer doce.\n\n'
          'Atividade física, alimentação equilibrada e descanso adequado podem ajudar. '
          'Se os sintomas forem muito intensos, converse com um profissional.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('exame') || lowerQ.contains('preventiv') || lowerQ.contains('papanicolau')) {
      return 'O Papanicolau deve ser feito a partir dos 25 anos (ou início da vida sexual). '
          'A mamografia é recomendada a partir dos 40 anos.\n\n'
          'Esses exames são gratuitos na UBS! Agende o seu.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('anticoncepcional') || lowerQ.contains('pílula')) {
      return 'Existem diversos métodos anticoncepcionais: pílula, DIU, implante, injeção, preservativo, etc. '
          'Cada mulher tem necessidades diferentes.\n\n'
          'Converse com um profissional de saúde na UBS para escolher o melhor método para você.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('menopausa') || lowerQ.contains('climatério')) {
      return 'A menopausa geralmente ocorre entre 45 e 55 anos. '
          'Sintomas como ondas de calor, alterações de humor e ressecamento são comuns.\n\n'
          'Atividade física, alimentação rica em cálcio e acompanhamento médico são essenciais nesta fase.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    if (lowerQ.contains('violência') || lowerQ.contains('agress') || lowerQ.contains('abus')) {
      return '🚨 Se você está em situação de violência, procure ajuda:\n\n'
          '• Disque 180 - Central de Atendimento à Mulher (24h, gratuito)\n'
          '• 190 - Polícia Militar\n'
          '• Delegacia da Mulher\n\n'
          'Você não está sozinha. Existem pessoas e serviços prontos para ajudar.\n\n'
          '⚠️ ${AppStrings.avisoLegal}';
    }

    return 'Obrigada pela sua pergunta! Para uma resposta mais precisa, '
        'recomendo que você explore a seção de Conteúdos do app ou '
        'consulte uma profissional de saúde na UBS mais próxima.\n\n'
        'Posso ajudar com dúvidas sobre ciclo menstrual, corrimento, cólica, '
        'TPM, exames preventivos, anticoncepcionais, menopausa e autocuidado.\n\n'
        '⚠️ ${AppStrings.avisoLegal}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Perguntas Anônimas',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Aviso de privacidade
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.softPink.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_rounded, size: 16, color: AppColors.primaryPink),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suas perguntas são anônimas e não são armazenadas.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPink.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Digite sua pergunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.cream,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primaryPink : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: (message.isUser ? AppColors.primaryPink : Colors.black)
                  .withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 14,
            color: message.isUser ? Colors.white : AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
