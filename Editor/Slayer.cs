using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace saberslay.Slayer.SlayerShader{
    public class Slayer : ShaderGUI {
        public static void linkButton(int Width, int Height, string title, string link) {
            if (GUILayout.Button(title, GUILayout.Width(Width), GUILayout.Height(Height))) {
                Application.OpenURL(link);
            }
        }
        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
            // render the default gui
            base.OnGUI(materialEditor, properties);

            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            Slayer.linkButton(70, 20, "Github", "https://github.com/saberslay/SlayerShader");
            GUILayout.Space(2);
            Slayer.linkButton(150, 20, "Support me on patreon", "https://www.patreon.com/saberslay");
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();
        }
    }
}
