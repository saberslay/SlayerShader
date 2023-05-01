using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
    public class Slayer : ShaderGUI {
        public static void linkButton(int Width, int Height, string title, string link) {
            if (GUILayout.Button(title, GUILayout.Width(Width), GUILayout.Height(Height))) {
                Application.OpenURL(link);
            }
        }

<<<<<<< Updated upstream
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
        // render the default gui
        base.OnGUI(materialEditor, properties);

        EditorGUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        Slayer.linkButton(70, 20, "Github", "https://github.com/saberslay/SlayerShader");
        GUILayout.Space(2);
        Slayer.linkButton(70, 20, "Buy a Coffee", "https://ko-fi.com/saberslay");
        GUILayout.FlexibleSpace();
        EditorGUILayout.EndHorizontal();
    }
}
=======
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            Slayer.linkButton(70, 20, "Github", "https://github.com/saberslay/SlayerShader");
            GUILayout.Space(2);
            Slayer.linkButton(70, 20, "Donate", "https://paypal.me/saberslay");
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
            base.OnGUI(materialEditor, properties);
        }
    }
>>>>>>> Stashed changes
