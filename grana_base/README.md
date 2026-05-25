# GranaBase — Flutter App

App de gerenciamento financeiro pessoal. Controle receitas, despesas, saldo e fundo de reserva.

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x ou superior
- Backend `grana_base_api` rodando (ver `../grana_base_api/README.md`)
- Dispositivo físico ou emulador Android/iOS

---

## Configuração

### 1. Instalar dependências

```bash
flutter pub get
```

### 2. Definir a URL do backend

Edite `lib/core/config/api_config.dart` de acordo com o ambiente:

| Ambiente | URL |
|---|---|
| Android emulador | `http://10.0.2.2:8080` |
| iOS simulador | `http://localhost:8080` |
| Device físico (Wi-Fi) | `http://<IP_DA_MÁQUINA>:8080` |

Para descobrir o IP da sua máquina no Windows:
```powershell
ipconfig
# procure "Endereço IPv4" na sua rede Wi-Fi
```

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.100:8080';
}
```

---

## Rodando o app

```bash
flutter run
```

Para escolher o dispositivo:
```bash
flutter devices       # lista dispositivos disponíveis
flutter run -d <id>   # roda em um dispositivo específico
```

---

## Estrutura do projeto

```
lib/
├── app/
│   ├── app_widget.dart          # MaterialApp + providers
│   └── auth_gate.dart           # Roteamento autenticado/não autenticado
├── core/
│   ├── config/
│   │   └── api_config.dart      # URL base do backend
│   ├── services/
│   │   └── api_client.dart      # Cliente HTTP com JWT
│   └── utils/
│       └── formatters.dart      # Formatação de moeda (R$ 1.200,00)
├── models/                      # Entidades: Transaction, Category, etc.
├── providers/
│   └── auth_provider.dart       # Estado de autenticação (JWT)
├── screens/
│   ├── auth/login_screen.dart
│   ├── home/home_screen.dart
│   ├── splash/splash_screen.dart
│   ├── transactions/
│   └── reserve/
└── services/                    # Chamadas HTTP para o backend
```

---

## Funcionalidades

- **Autenticação** — cadastro e login com JWT (token expira em 7 dias)
- **Transações** — cadastrar, editar e excluir receitas e despesas com paginação
- **Resumo financeiro** — receitas, despesas e saldo calculados sobre todas as transações
- **Fundo de reserva** — meta de valor com registro de aportes e barra de progresso
- **Splash screen** — animação de logo reveal na abertura

---

## Gerando ícones e splash

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

---

## Observações

- Em Android físico, o dispositivo deve estar na **mesma rede Wi-Fi** que a máquina rodando o backend.
- O app usa HTTP. Para produção, configure HTTPS no backend e remova `android:usesCleartextTraffic="true"` do `AndroidManifest.xml`.
