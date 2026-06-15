import re
import os

file_path = "lib/modules/settings/views/profile_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Make sure l10n is available in build
if "final l10n = AppLocalizations.of(context)!;" not in content:
    content = content.replace("final authState = ref.watch(authControllerProvider);", 
                              "final l10n = AppLocalizations.of(context)!;\n    final authState = ref.watch(authControllerProvider);")

# Update texts
content = content.replace("'Toplam Not'", "l10n.totalNotes")
content = content.replace("'Toplam Görev'", "l10n.totalTasks")
content = content.replace("'Tamamlanan'", "l10n.completedSingle")
content = content.replace("'Profili Düzenle'", "l10n.editProfile")

content = content.replace("'Sistem'", "l10n.themeSystem")
content = content.replace("'Aydınlık'", "l10n.themeLight")
content = content.replace("'Karanlık'", "l10n.themeDark")

content = content.replace("'Görünüm Seçimi'", "l10n.appearanceSelection")
content = content.replace("'Yazı Tipi Seçimi'", "l10n.fontSelection")

content = content.replace("'İptal'", "l10n.cancel")
content = content.replace("'Hesabı Sil'", "l10n.deleteAccountTitle")
content = content.replace("'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.'", "l10n.deleteAccountDesc")
content = content.replace("'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.'", "l10n.deleteAccountDesc")
content = content.replace("'Hesabnz silmek istediYinize emin misiniz? Bu iYlem geri alnamaz ve tǬm verileriniz kalc olarak silinir.'", "l10n.deleteAccountDesc")

content = content.replace("'Evet, Hesabımı Sil'", "l10n.yesDeleteAccount")
content = content.replace("'Evet, Hesabm Sil'", "l10n.yesDeleteAccount")

content = content.replace("title: const Text('Görünüm Seçimi')", "title: Text(l10n.appearanceSelection)")
content = content.replace("title: const Text('Yazı Tipi Seçimi')", "title: Text(l10n.fontSelection)")
content = content.replace("title: const Text('Hesabı Sil')", "title: Text(l10n.deleteAccountTitle)")

content = content.replace("const Text('Sistem (Cihaz Ayarı)')", "Text('${l10n.themeSystem} (Cihaz Ayarı)')")
content = content.replace("const Text('Aydınlık Mod')", "Text('${l10n.themeLight} Mod')")
content = content.replace("const Text('Karanlık Mod')", "Text('${l10n.themeDark} Mod')")


content = content.replace("child: const Text('İptal')", "child: Text(l10n.cancel)")
content = content.replace("child: const Text('Evet, Hesabımı Sil')", "child: Text(l10n.yesDeleteAccount)")
content = content.replace("content: const Text(\n                            'Hesabnz silmek istediYinize emin misiniz? Bu iYlem geri alnamaz ve tǬm verileriniz kalc olarak silinir.',\n                          )", "content: Text(l10n.deleteAccountDesc)")
content = content.replace("content: const Text(\n                            'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.',\n                          )", "content: Text(l10n.deleteAccountDesc)")
content = content.replace("content: const Text(\n                            'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinir.',\n                          )", "content: Text(l10n.deleteAccountDesc)")


with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Updated profile_screen.dart")
