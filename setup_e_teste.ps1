# =============================================
# LAÇO'S - Script de Setup e Teste
# =============================================

$SUPABASE_URL = "https://xenmssqqnoeuukxwczdy.supabase.co"
$SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhlbm1zc3Fxbm9ldXVreHdjemR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5MTk5MDQsImV4cCI6MjA5MzQ5NTkwNH0.Bnv-xCDXEst2ZDSR_0ic6I1rEG7czusA9WWzbN_qXu4"

# Dados do usuario de teste
$TEST_EMAIL = "teste@lacos.com"
$TEST_PASSWORD = "Teste@123"
$TEST_NOME = "Maria Teste"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "  LACO'S - Setup e Criacao de Usuario" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""

# ---- PASSO 1: Criar usuario de teste via Supabase Auth API ----
Write-Host "[1/3] Criando usuario de teste..." -ForegroundColor Cyan
Write-Host "  Email: $TEST_EMAIL" -ForegroundColor Yellow
Write-Host "  Senha: $TEST_PASSWORD" -ForegroundColor Yellow

try {
    $signupBody = @{
        email = $TEST_EMAIL
        password = $TEST_PASSWORD
    } | ConvertTo-Json

    $signupResponse = Invoke-RestMethod -Uri "$SUPABASE_URL/auth/v1/signup" `
        -Method POST `
        -Headers @{
            "apikey" = $SUPABASE_ANON_KEY
            "Content-Type" = "application/json"
        } `
        -Body $signupBody `
        -ErrorAction Stop

    $userId = $signupResponse.id
    if (-not $userId) {
        $userId = $signupResponse.user.id
    }

    if ($userId) {
        Write-Host "  Usuario criado com sucesso! ID: $userId" -ForegroundColor Green
    } else {
        Write-Host "  Usuario pode ja existir. Tentando fazer login..." -ForegroundColor Yellow
    }
} catch {
    $errorMsg = $_.ErrorDetails.Message
    if ($errorMsg -match "already registered" -or $errorMsg -match "already exists") {
        Write-Host "  Usuario ja existe - OK!" -ForegroundColor Green
    } else {
        Write-Host "  Aviso: $errorMsg" -ForegroundColor Yellow
        Write-Host "  Tentando fazer login mesmo assim..." -ForegroundColor Yellow
    }
}

# ---- PASSO 2: Fazer login para obter o token e criar perfil ----
Write-Host ""
Write-Host "[2/3] Fazendo login de teste..." -ForegroundColor Cyan

try {
    $loginBody = @{
        email = $TEST_EMAIL
        password = $TEST_PASSWORD
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "$SUPABASE_URL/auth/v1/token?grant_type=password" `
        -Method POST `
        -Headers @{
            "apikey" = $SUPABASE_ANON_KEY
            "Content-Type" = "application/json"
        } `
        -Body $loginBody `
        -ErrorAction Stop

    $accessToken = $loginResponse.access_token
    $userId = $loginResponse.user.id

    Write-Host "  Login OK! Token obtido." -ForegroundColor Green
    Write-Host "  User ID: $userId" -ForegroundColor Green

    # Criar perfil na tabela usuarias
    Write-Host ""
    Write-Host "[3/3] Criando perfil na tabela usuarias..." -ForegroundColor Cyan

    try {
        $profileBody = @{
            id = $userId
            nome = $TEST_NOME
            email = $TEST_EMAIL
            idade = 28
            fase_da_vida = "Adulta"
        } | ConvertTo-Json

        $profileResponse = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/usuarias" `
            -Method POST `
            -Headers @{
                "apikey" = $SUPABASE_ANON_KEY
                "Authorization" = "Bearer $accessToken"
                "Content-Type" = "application/json"
                "Prefer" = "return=minimal"
            } `
            -Body $profileBody `
            -ErrorAction Stop

        Write-Host "  Perfil criado com sucesso!" -ForegroundColor Green
    } catch {
        $profileError = $_.ErrorDetails.Message
        if ($profileError -match "duplicate" -or $profileError -match "already exists" -or $profileError -match "23505") {
            Write-Host "  Perfil ja existe - OK!" -ForegroundColor Green
        } else {
            Write-Host "  Aviso ao criar perfil: $profileError" -ForegroundColor Yellow
            Write-Host "  O perfil sera criado automaticamente no primeiro cadastro pelo app." -ForegroundColor Yellow
        }
    }

} catch {
    Write-Host "  Erro no login: $($_.ErrorDetails.Message)" -ForegroundColor Red
    Write-Host "  Verifique se o Supabase esta configurado e as tabelas foram criadas." -ForegroundColor Red
    Write-Host ""
    Write-Host "  IMPORTANTE: Execute o arquivo supabase_schema.sql no SQL Editor do Supabase!" -ForegroundColor Yellow
    Write-Host "  Link: https://supabase.com/dashboard/project/xenmssqqnoeuukxwczdy/sql" -ForegroundColor Yellow
}

# ---- RESULTADO FINAL ----
Write-Host ""
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "  DADOS PARA LOGIN NO APP:" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Email: $TEST_EMAIL" -ForegroundColor White
Write-Host "  Senha: $TEST_PASSWORD" -ForegroundColor White
Write-Host ""
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Para rodar o app no emulador:" -ForegroundColor Cyan
Write-Host '  $env:ANDROID_HOME = "D:\AndroidSDK"' -ForegroundColor Gray
Write-Host '  $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"' -ForegroundColor Gray
Write-Host '  D:\flutter\bin\flutter.bat run' -ForegroundColor Gray
Write-Host ""
