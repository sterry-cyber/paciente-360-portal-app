#!/usr/bin/env python
"""
Script para probar el login con las credenciales de STERRY y WAYMARA
"""
import requests
import json

def test_login():
    """Probar el login con las credenciales creadas"""
    
    base_url = "http://localhost:8001/api"
    
    print("🧪 Probando sistema de login de Paciente 360")
    print("=" * 50)
    
    # Credenciales de prueba
    credentials = [
        {
            'name': 'STERRY (Paciente)',
            'email': 'sterry@paciente360.com',
            'password': 'sterry123',
            'expected_role': 'patient'
        },
        {
            'name': 'WAYMARA (Doctor)',
            'email': 'waymara@paciente360.com',
            'password': 'waymara123',
            'expected_role': 'doctor'
        }
    ]
    
    for cred in credentials:
        print(f"\n🔐 Probando login para {cred['name']}...")
        
        try:
            # Hacer petición de login
            response = requests.post(
            f"{base_url}/auth/simple-login/",
                json={
                    'email': cred['email'],
                    'password': cred['password']
                },
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            
            if response.status_code == 200:
                data = response.json()
                
                if 'tokens' in data and 'user' in data:
                    user_data = data['user']
                    token = data['tokens']['access']
                    
                    print(f"✅ Login exitoso para {cred['name']}")
                    print(f"   Nombre: {user_data.get('first_name')} {user_data.get('last_name')}")
                    print(f"   Email: {user_data.get('email')}")
                    print(f"   Rol: {user_data.get('role')}")
                    print(f"   Token: {token[:20]}...")
                    
                    # Verificar rol
                    if user_data.get('role') == cred['expected_role']:
                        print(f"✅ Rol correcto: {cred['expected_role']}")
                    else:
                        print(f"❌ Rol incorrecto. Esperado: {cred['expected_role']}, Obtenido: {user_data.get('role')}")
                    
                    # Probar endpoint protegido
                    test_protected_endpoint(token, cred['name'])
                    
                else:
                    print(f"❌ Respuesta de login inválida para {cred['name']}")
                    print(f"   Respuesta: {data}")
            else:
                print(f"❌ Error en login para {cred['name']}")
                print(f"   Status Code: {response.status_code}")
                print(f"   Respuesta: {response.text}")
                
        except requests.exceptions.ConnectionError:
            print(f"❌ No se pudo conectar al servidor para {cred['name']}")
            print("   Asegúrate de que el servidor Django esté ejecutándose en http://localhost:8000")
        except Exception as e:
            print(f"❌ Error inesperado para {cred['name']}: {e}")
    
    print("\n" + "=" * 50)
    print("🏁 Pruebas de login completadas")

def test_protected_endpoint(token, user_name):
    """Probar un endpoint protegido con el token"""
    try:
        headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }
        
        response = requests.get(
            "http://localhost:8001/api/auth/me/",
            headers=headers,
            timeout=10
        )
        
        if response.status_code == 200:
            user_data = response.json()
            print(f"✅ Endpoint protegido accesible para {user_name}")
            print(f"   Usuario verificado: {user_data.get('first_name')} {user_data.get('last_name')}")
        else:
            print(f"❌ Error en endpoint protegido para {user_name}")
            print(f"   Status Code: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Error probando endpoint protegido para {user_name}: {e}")

if __name__ == '__main__':
    test_login()
