import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 1. LOGIN COM EMAIL E SENHA
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Traduz os erros mais comuns do Firebase para o usuário
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw 'E-mail ou senha incorretos.';
      } else if (e.code == 'invalid-email') {
        throw 'O formato do e-mail digitado é inválido.';
      } else if (e.code == 'user-disabled') {
        throw 'Este usuário foi desativado.';
      }
      throw e.message ?? 'Erro desconhecido ao fazer login.';
    } catch (e) {
      throw 'Erro de conexão: $e';
    }
  }

  /// 2. LOGIN COM GOOGLE
  Future<User?> signInWithGoogle() async {
    try {
      // Inicia o fluxo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Se o usuário cancelar, retorna nulo
      if (googleUser == null) return null;

      // Obtém os dados de autenticação da conta Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria a credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autentica no Firebase com a credencial obtida
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
      
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro ao autenticar com o Firebase.';
    } catch (e) {
      throw 'Erro ao conectar com a conta Google: $e';
    }
  }

  /// 3. FUNÇÃO DE LOGOUT (SAIR DA CONTA)
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}