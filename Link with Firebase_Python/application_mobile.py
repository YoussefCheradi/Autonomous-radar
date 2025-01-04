import firebase_admin
from firebase_admin import credentials, firestore, storage
from google.cloud.firestore_v1 import Increment
import os

# Charger les informations d'identification et initialiser Firebase
cred = credentials.Certificate("projet-login-3cef0-firebase-adminsdk-8tyg7-728956d945.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'projet-login-3cef0.appspot.com'  # Remplacez 'your-project-id' par votre ID de projet Firebase
})

# Initialiser le client Firestore
db = firestore.client()

# Initialiser le client Firebase Storage
bucket = storage.bucket()

# Fonction pour télécharger un fichier sur Firebase Storage et retourner l'URL
def upload_file_to_storage(file_path):
    try:
        blob = bucket.blob(os.path.basename(file_path))
        blob.upload_from_filename(file_path, timeout=250)  # Augmenter le timeout à 60 secondes (ou plus selon vos besoins)
        blob.make_public()  # Rendre le fichier public
        return blob.public_url
    except Exception as e:
            print(f"Erreur lors du téléchargement du fichier {file_path}: {e}")
            return None 

# Données à ajouter
data = {
    "nature d'infraction": 'Absence de casque',
    'localisation': 'agadir',
    'date': '12/06/2030',
    'prix': '100DH',
    'image': '',  # Ceci sera mis à jour avec l'URL de l'image
    'video': '',  # Ceci sera mis à jour avec l'URL de la vidéo
    'PV': '',     # Ceci sera mis à jour avec l'URL du PV
}

# ID à rechercher
search_id = "A123"

# Chemins des fichiers à télécharger
image_path = 'detection.png'  # Remplacez par le chemin de votre image
video_path = 'prediction.mp4'   # Remplacez par le chemin de votre vidéo
pv_path = 'PV.png'         # Remplacez par le chemin de votre PV

def add_infraction_to_matching_id():
    # Récupérer les URL des fichiers et les mettre à jour dans les données
    data['image'] = upload_file_to_storage(image_path)
    data['video'] = upload_file_to_storage(video_path)
    data['PV'] = upload_file_to_storage(pv_path)

    # Récupérer tous les utilisateurs
    users_ref = db.collection('users')
    users = users_ref.stream()
    
    # Parcourir tous les utilisateurs
    for user in users:
        user_id = user.id
        infractions_ref = db.collection('users').document(user_id).collection('infractions').document('infraction1')
        print(user_id)
        # Récupérer les données de la sous-collection 'infraction1'
        infraction_data = infractions_ref.get().to_dict()
        print(infraction_data)
        # Vérifier si l'ID correspond
        if infraction_data and infraction_data.get('MT') == search_id:
            # Récupérer la référence au document 'infractionCounter' pour cet utilisateur
            counter_ref = db.collection('infractionCounter').document(user_id)
            
            # Vérifier si le document de compteur existe
            if not counter_ref.get().exists:
                # Si le document n'existe pas, le créer avec une valeur de compteur initiale de 0
                counter_ref.set({'count': 0})

            # Incrémenter la valeur de 'count' dans 'infractionCounter'
            counter_ref.update({'count': Increment(1)})
            count_value = counter_ref.get().to_dict().get('count')  # Récupérer la valeur de count après l'incrémentation
            print(f"La valeur du compteur pour l'utilisateur {user_id} a été incrémentée à {count_value}")

            # Créer un nouveau document dans la sous-collection 'infractions' avec les nouvelles données
            new_infraction_ref = db.collection('users').document(user_id).collection('infractions').document(f"infraction{count_value}")
            new_infraction_ref.set(data)
            print(f"Nouveau document 'infraction{count_value}' créé pour l'utilisateur {user_id} avec l'ID {search_id}")

# Appel de la fonction pour rechercher et ajouter les données
add_infraction_to_matching_id()
