-- =============================================
-- LAÇO'S - MINHA SAÚDE FEMININA
-- Supabase Database Schema
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABELA: usuarias
-- =============================================
CREATE TABLE IF NOT EXISTS public.usuarias (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome TEXT NOT NULL,
  idade INT,
  email TEXT UNIQUE NOT NULL,
  fase_da_vida TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_usuarias_email ON public.usuarias(email);

-- =============================================
-- TABELA: ciclos_menstruais
-- =============================================
CREATE TABLE IF NOT EXISTS public.ciclos_menstruais (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL REFERENCES public.usuarias(id) ON DELETE CASCADE,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  intensidade TEXT,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_ciclos_usuario ON public.ciclos_menstruais(usuario_id);
CREATE INDEX idx_ciclos_data ON public.ciclos_menstruais(data_inicio);

-- =============================================
-- TABELA: sintomas
-- =============================================
CREATE TABLE IF NOT EXISTS public.sintomas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL REFERENCES public.usuarias(id) ON DELETE CASCADE,
  tipo TEXT NOT NULL,
  intensidade TEXT,
  data TIMESTAMPTZ DEFAULT NOW(),
  descricao TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_sintomas_usuario ON public.sintomas(usuario_id);
CREATE INDEX idx_sintomas_data ON public.sintomas(data);

-- =============================================
-- TABELA: conteudos
-- =============================================
CREATE TABLE IF NOT EXISTS public.conteudos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  titulo TEXT NOT NULL,
  categoria TEXT NOT NULL,
  descricao TEXT,
  fase_da_vida TEXT,
  o_que_e_normal TEXT,
  sinais_alerta TEXT,
  quando_procurar_ubs TEXT,
  o_que_fazer_em_casa TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_conteudos_categoria ON public.conteudos(categoria);
CREATE INDEX idx_conteudos_fase ON public.conteudos(fase_da_vida);

-- =============================================
-- TABELA: lembretes
-- =============================================
CREATE TABLE IF NOT EXISTS public.lembretes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL REFERENCES public.usuarias(id) ON DELETE CASCADE,
  tipo TEXT NOT NULL,
  data TIMESTAMPTZ NOT NULL,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lembretes_usuario ON public.lembretes(usuario_id);
CREATE INDEX idx_lembretes_data ON public.lembretes(data);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE public.usuarias ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ciclos_menstruais ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sintomas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conteudos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lembretes ENABLE ROW LEVEL SECURITY;

-- Usuarias: users can only see/edit their own data
CREATE POLICY "Users can view own profile" ON public.usuarias
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.usuarias
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.usuarias
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Ciclos: users can only access their own cycles
CREATE POLICY "Users can view own cycles" ON public.ciclos_menstruais
  FOR SELECT USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own cycles" ON public.ciclos_menstruais
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own cycles" ON public.ciclos_menstruais
  FOR UPDATE USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own cycles" ON public.ciclos_menstruais
  FOR DELETE USING (auth.uid() = usuario_id);

-- Sintomas: users can only access their own symptoms
CREATE POLICY "Users can view own symptoms" ON public.sintomas
  FOR SELECT USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own symptoms" ON public.sintomas
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own symptoms" ON public.sintomas
  FOR UPDATE USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own symptoms" ON public.sintomas
  FOR DELETE USING (auth.uid() = usuario_id);

-- Conteudos: everyone can read
CREATE POLICY "Anyone can view content" ON public.conteudos
  FOR SELECT USING (true);

-- Lembretes: users can only access their own reminders
CREATE POLICY "Users can view own reminders" ON public.lembretes
  FOR SELECT USING (auth.uid() = usuario_id);

CREATE POLICY "Users can insert own reminders" ON public.lembretes
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Users can update own reminders" ON public.lembretes
  FOR UPDATE USING (auth.uid() = usuario_id);

CREATE POLICY "Users can delete own reminders" ON public.lembretes
  FOR DELETE USING (auth.uid() = usuario_id);

-- =============================================
-- SEED: Conteúdos iniciais
-- =============================================

INSERT INTO public.conteudos (titulo, categoria, descricao, fase_da_vida, o_que_e_normal, sinais_alerta, quando_procurar_ubs, o_que_fazer_em_casa) VALUES

('Ciclo Menstrual: Entendendo seu corpo', 'Ciclo Menstrual',
 'O ciclo menstrual é o período entre o primeiro dia de uma menstruação e o primeiro dia da próxima. Dura em média 28 dias, mas pode variar de 21 a 35 dias.',
 'Todas',
 'Ciclos entre 21 e 35 dias, fluxo de 3 a 7 dias, cólicas leves nos primeiros dias.',
 'Ciclos menores que 21 dias ou maiores que 35 dias, sangramento muito intenso (trocar absorvente a cada hora), dor incapacitante.',
 'Se o ciclo estiver muito irregular por mais de 3 meses, se houver sangramento entre períodos, ou se as cólicas não melhorarem com analgésicos comuns.',
 'Manter um calendário menstrual, usar bolsa de água quente para cólicas, praticar exercícios leves, manter alimentação equilibrada.'),

('Corrimento Vaginal', 'Saúde Ginecológica',
 'O corrimento vaginal é uma secreção natural do corpo feminino que ajuda a manter a vagina limpa e protegida.',
 'Todas',
 'Corrimento transparente ou esbranquiçado, sem cheiro forte, que varia durante o ciclo.',
 'Corrimento amarelado, esverdeado ou acinzentado, com mau cheiro, coceira, ardência ou dor.',
 'Se o corrimento mudar de cor, cheiro ou consistência e vier acompanhado de coceira ou dor.',
 'Usar calcinha de algodão, evitar duchas vaginais, lavar a região externa com água e sabão neutro.'),

('Saúde Emocional e Hormônios', 'Saúde Emocional/Hormonal',
 'Os hormônios femininos influenciam diretamente o humor, o sono e a disposição. Conhecer essas variações ajuda a cuidar melhor de si mesma.',
 'Todas',
 'Variações de humor ao longo do ciclo, sensibilidade emocional antes da menstruação (TPM), alterações no sono.',
 'Tristeza persistente por mais de 2 semanas, ansiedade constante, perda de interesse em atividades, pensamentos negativos frequentes.',
 'Se os sintomas emocionais estiverem prejudicando o trabalho, estudos ou relacionamentos. Se houver pensamentos de automutilação.',
 'Praticar atividade física, manter rotina de sono, conversar com pessoas de confiança, praticar respiração profunda e meditação.'),

('Exames Preventivos', 'Saúde Preventiva',
 'Exames preventivos são fundamentais para detectar doenças precocemente. O Papanicolau e a mamografia são os principais exames para a saúde da mulher.',
 'Todas',
 'Realizar Papanicolau a partir dos 25 anos (ou início da vida sexual), mamografia a partir dos 40 anos.',
 'Sangramento após relação sexual, nódulos na mama, alterações na pele da mama, secreção pelo mamilo.',
 'Para realizar exames de rotina, se houver qualquer alteração nas mamas ou na região genital.',
 'Fazer autoexame das mamas mensalmente, manter acompanhamento regular, anotar datas dos últimos exames.'),

('Violência Contra a Mulher', 'Violência Contra a Mulher',
 'A violência contra a mulher pode ser física, psicológica, sexual, patrimonial ou moral. Reconhecer os sinais é o primeiro passo para buscar ajuda.',
 'Todas',
 'Relacionamentos saudáveis são baseados em respeito, diálogo e confiança mútua.',
 'Controle excessivo do parceiro, humilhações, ameaças, agressões físicas, isolamento social forçado, relação sexual forçada.',
 'Procure a UBS para atendimento e acolhimento. Ligue 180 (Central de Atendimento à Mulher) ou 190 (Polícia).',
 'Se estiver em perigo imediato, vá a um local seguro. Conte para alguém de confiança. Guarde provas (mensagens, fotos). Conheça seus direitos.'),

('Autocuidado Diário', 'Autocuidado',
 'O autocuidado é essencial para a saúde física e mental. Pequenas atitudes diárias fazem grande diferença no bem-estar.',
 'Todas',
 'Sentir necessidade de descanso, ter momentos de lazer, cuidar da alimentação e higiene pessoal.',
 'Negligenciar completamente a própria saúde, não conseguir realizar atividades básicas, exaustão constante.',
 'Se o cansaço for persistente, se houver dificuldade para realizar atividades do dia a dia.',
 'Reservar tempo para si mesma, manter alimentação equilibrada, beber água, dormir bem, praticar atividades prazerosas.'),

('Menopausa e Climatério', 'Fases da Vida',
 'A menopausa marca o fim dos ciclos menstruais e geralmente ocorre entre 45 e 55 anos. O climatério é o período de transição.',
 'Menopausa',
 'Irregularidade menstrual, ondas de calor, alterações de humor, ressecamento vaginal.',
 'Sangramento após 12 meses sem menstruar, ondas de calor muito intensas que prejudicam o dia a dia, depressão.',
 'Para acompanhamento médico da transição, para avaliar necessidade de reposição hormonal.',
 'Manter atividade física, alimentação rica em cálcio, usar roupas leves, manter hidratação.');
