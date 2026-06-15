import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import '../../../core/theme/theme_ext.dart';

class LegalDocumentsScreen extends StatelessWidget {
  const LegalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.legalDocuments),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLegalTile(context, AppLocalizations.of(context)!.privacyPolicy, 'gizlilik'),
          _buildLegalTile(context, AppLocalizations.of(context)!.termsOfUse, 'kullanim_kosullari'),
          _buildLegalTile(context, AppLocalizations.of(context)!.accountDeletionPolicy, 'hesap_silme'),
          _buildLegalTile(context, AppLocalizations.of(context)!.kvkkText, 'kvkk'),
          _buildLegalTile(context, AppLocalizations.of(context)!.appStorePrivacy, 'app_store_privacy'),
          _buildLegalTile(context, AppLocalizations.of(context)!.googlePlayData, 'google_play_data'),
        ],
      ),
    );
  }

  Widget _buildLegalTile(BuildContext context, String title, String documentId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.dividerColor.withOpacity(0.5)),
      ),
      color: context.bgSurface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(Icons.description_outlined, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.chevron_right_rounded, color: context.textTertiary),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LegalDocumentReaderScreen(title: title, documentId: documentId),
            ),
          );
        },
      ),
    );
  }
}

class LegalDocumentReaderScreen extends StatelessWidget {
  final String title;
  final String documentId;

  const LegalDocumentReaderScreen({
    super.key,
    required this.title,
    required this.documentId,
  });

  String _getDocumentContent(BuildContext context) {
    switch (documentId) {
      case 'gizlilik':
        return Localizations.localeOf(context).languageCode == 'tr' ? _gizlilik : _gizlilik_en;
      case 'kullanim_kosullari':
        return Localizations.localeOf(context).languageCode == 'tr' ? _kullanimKosullari : _kullanimKosullari_en;
      case 'hesap_silme':
        return Localizations.localeOf(context).languageCode == 'tr' ? _hesapSilme : _hesapSilme_en;
      case 'kvkk':
        return Localizations.localeOf(context).languageCode == 'tr' ? _kvkk : _kvkk_en;
      case 'app_store_privacy':
        return Localizations.localeOf(context).languageCode == 'tr' ? _appStorePrivacy : _appStorePrivacy_en;
      case 'google_play_data':
        return Localizations.localeOf(context).languageCode == 'tr' ? _googlePlayData : _googlePlayData_en;
      default:
        return AppLocalizations.of(context)!.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 18)),
      ),
      body: Markdown(
        data: _getDocumentContent(context),
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          p: TextStyle(fontSize: 15, height: 1.6, color: context.textPrimary),
          listBullet: TextStyle(fontSize: 15, color: context.textPrimary),
        ),
      ),
    );
  }
}

// === METİNLER ===

const String _kullanimKosullari = '''
# NOTIVA KULLANIM KOŞULLARI

**Son Güncelleme Tarihi:** 01.07.2026

Bu Kullanım Koşulları, Notiva mobil uygulaması ve ilgili hizmetlerin kullanımına ilişkin kuralları belirlemektedir. Notiva'yı indirerek, kayıt olarak veya kullanmaya devam ederek aşağıdaki şartları kabul etmiş sayılırsınız.

Bu koşulları kabul etmiyorsanız uygulamayı kullanmamanız gerekmektedir.

---

## 1. Hizmet Tanımı
Notiva;
* Not oluşturma
* Görev yönetimi
* Yapılacaklar listeleri oluşturma
* Hatırlatıcı kurma
* Takvim yönetimi
* Kanban panoları oluşturma
* Ekip yönetimi
* Ortak çalışma alanları oluşturma
* Dosya paylaşımı
gibi verimlilik ve iş birliği hizmetleri sunan dijital bir platformdur.

---

## 2. Hesap Oluşturma
Notiva hizmetlerinden yararlanabilmek için kullanıcı hesabı oluşturmanız gerekebilir.
Kullanıcı;
* Doğru ve güncel bilgiler vermekle,
* Hesap güvenliğini korumakla,
* Şifresini üçüncü kişilerle paylaşmamakla
sorumludur. Kullanıcı hesabında gerçekleştirilen işlemlerden hesap sahibi sorumludur.

---

## 3. Kullanıcı Sorumlulukları
Notiva kullanıcıları:
* Yürürlükteki yasalara uygun davranmayı,
* Başkalarının haklarını ihlal etmemeyi,
* Uygulamayı kötüye kullanmamayı,
* Yanıltıcı veya zararlı içerik paylaşmamayı
kabul eder.

---

## 4. Yasaklanan Kullanımlar
Aşağıdaki faaliyetler kesinlikle yasaktır:
* Yasadışı içerik paylaşılması
* Zararlı yazılım yüklenmesi veya dağıtılması
* Sistem güvenliğini ihlal etmeye yönelik girişimler
* Yetkisiz erişim girişimleri
* Spam veya toplu istenmeyen içerik paylaşımı
* Başka kullanıcıların hesaplarına erişmeye çalışılması
* Fikri mülkiyet haklarını ihlal eden içerikler paylaşılması

Notiva bu tür durumlarda hesapları askıya alma veya kalıcı olarak kapatma hakkını saklı tutar.

---

## 5. Ortak Alanlar ve Ekip Kullanımı
Notiva kullanıcıları ortak çalışma alanları oluşturabilir ve ekip üyeleri davet edebilir.
Ortak alanlarda oluşturulan:
* Notlar
* Görevler
* Dosyalar
* Yorumlar
* Aktivite kayıtları
ilgili çalışma alanındaki yetkili kullanıcılar tarafından görüntülenebilir. Ortak alanlarda paylaşılan içeriklerin sorumluluğu içerik sahibine aittir.

---

## 6. Abonelik Planları
Notiva ücretsiz ve ücretli abonelik planları sunabilir. Plan içerikleri ve fiyatları zaman içerisinde güncellenebilir.
Ücretli planlar aşağıdaki örnek özellikleri içerebilir:
* Sınırsız kullanım hakları
* Ortak çalışma alanları
* Dosya yükleme
* Ekip yönetimi
* Gelişmiş özellikler
Plan detayları uygulama içerisinde ayrıca gösterilir.

---

## 7. Ödemeler ve Abonelik Yenilemeleri
Abonelik satın alma işlemleri:
* Apple App Store
* Google Play Store
üzerinden gerçekleştirilir. Abonelikler ilgili mağaza tarafından otomatik yenilenebilir.
Abonelik iptali kullanıcı tarafından ilgili mağaza hesabı üzerinden yapılmalıdır. Notiva, mağaza tarafından gerçekleştirilen ödeme işlemlerinden doğrudan sorumlu değildir.

---

## 8. Hesap Silme
Kullanıcılar istedikleri zaman hesaplarını uygulama içerisinden silebilir.
Hesap silme işlemi sonrasında:
* Hesap bilgileri
* Kişisel notlar
* Görevler
* Yapılacaklar listeleri
* Hatırlatıcılar
sistemden kaldırılabilir veya anonim hale getirilebilir. Hesap silme işlemi geri alınamaz.

---

## 9. Fikri Mülkiyet Hakları
Notiva uygulaması, tasarımı, logosu, yazılımı, marka unsurları ve içerikleri ilgili fikri mülkiyet mevzuatı kapsamında korunmaktadır.
Kullanıcılar Notiva'nın hiçbir bölümünü:
* Kopyalayamaz,
* Çoğaltamaz,
* Satamaz,
* Kiralayamaz,
* Tersine mühendislik yapamaz,
veya ticari amaçla kullanamaz.

---

## 10. Hizmette Değişiklik Yapılması
Notiva;
* Yeni özellik ekleme,
* Özellik kaldırma,
* Hizmetleri değiştirme,
* Hizmeti geçici veya kalıcı olarak sonlandırma
hakkını saklı tutar.

---

## 11. Sorumluluk Sınırı
Notiva;
* Kullanıcıların oluşturduğu içeriklerden,
* Kullanıcılar arasındaki anlaşmazlıklardan,
* Üçüncü taraf hizmet sağlayıcılarından kaynaklanan kesintilerden,
* İnternet bağlantısı veya cihaz kaynaklı sorunlardan
sorumlu tutulamaz. Kullanıcılar uygulamayı kendi sorumlulukları altında kullanmaktadır.

---

## 12. Hesap Askıya Alma ve Sonlandırma
Notiva aşağıdaki durumlarda kullanıcı hesaplarını geçici veya kalıcı olarak kapatabilir:
* Kullanım koşullarının ihlali
* Yasadışı faaliyetler
* Sistem güvenliğini tehdit eden davranışlar
* Diğer kullanıcıların haklarının ihlali
Bu durumda önceden bildirim yapılması zorunlu değildir.

---

## 13. Kullanım Koşullarında Değişiklik
Notiva bu Kullanım Koşullarını güncelleme hakkını saklı tutar.
Güncellenen koşullar yayınlandığı tarihten itibaren yürürlüğe girer.
Kullanıcıların uygulamayı kullanmaya devam etmesi güncellenen şartların kabul edildiği anlamına gelir.

---

## 14. İletişim
Kullanım Koşulları ile ilgili sorularınız için aşağıdaki iletişim adresi kullanılabilir:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek bu Kullanım Koşullarını kabul etmiş sayılırsınız.*
''';

const String _hesapSilme = '''
# NOTIVA HESAP SİLME POLİTİKASI

**Son Güncelleme Tarihi:** 01.07.2026

Bu Hesap Silme Politikası, Notiva kullanıcılarının hesaplarını nasıl silebileceklerini, hesap silme işlemi sonrasında hangi verilerin kaldırılacağını ve hangi durumlarda bazı kayıtların saklanabileceğini açıklamaktadır.

Notiva, kullanıcıların hesaplarını uygulama içerisinden kolayca silebilmelerine olanak tanımaktadır.

---

## 1. Hesap Silme Hakkı
Tüm Notiva kullanıcıları, herhangi bir gerekçe göstermeksizin hesaplarını istedikleri zaman silebilir. Hesap silme işlemi uygulama içerisinden gerçekleştirilebilir.
İşlem adımları:
**Profil > Ayarlar > Hesabımı Kalıcı Olarak Sil**

---

## 2. Hesap Silme İşleminin Sonuçları
Hesap silme işlemi tamamlandığında kullanıcıya ait kişisel veriler ve içerikler sistemden kaldırılmaya başlanır. Bunlar arasında:
* Profil bilgileri
* Ad ve soyad bilgileri
* Profil fotoğrafı
* E-posta adresi
* Kişisel notlar
* Kişisel görevler
* Yapılacaklar listeleri (To Do)
* Hatırlatıcılar
* Etiketler
* Kişisel dosya ekleri
* Kişisel çalışma alanları
yer alabilir.

---

## 3. Ortak Alanlar ve Ekip Verileri
Notiva ekip çalışmasını destekleyen ortak çalışma alanları sunmaktadır.
Bir kullanıcının hesap silme işlemi gerçekleştirmesi durumunda:
* Ortak alanlarda oluşturduğu görevler,
* Ortak alanlarda yaptığı yorumlar,
* Aktivite kayıtları,
* Ekip çalışmasını etkileyebilecek içerikler
ekip bütünlüğünün korunabilmesi amacıyla sistemde tutulabilir.
Bu durumlarda kullanıcı bilgileri anonim hale getirilebilir ve ilgili içerikler **"Silinmiş Kullanıcı"** olarak gösterilebilir.

---

## 4. Dosyalar ve Ekler
Kullanıcı tarafından yüklenen kişisel dosyalar hesap silme işlemi sonrasında sistemden kaldırılır.
Ortak alanlara yüklenen ve ekip çalışmalarının devamlılığı için gerekli olan dosyalar, ilgili çalışma alanı yöneticisinin erişiminde kalabilir.

---

## 5. Abonelikler Hakkında Önemli Bilgilendirme
Notiva abonelikleri:
* Apple App Store
* Google Play Store
üzerinden yönetilmektedir.

**Hesabın silinmesi aktif abonelikleri otomatik olarak iptal etmez.**
Kullanıcılar aboneliklerini ayrıca ilgili mağaza hesabı üzerinden iptal etmekle yükümlüdür. Aksi halde mağaza tarafından abonelik yenilemeleri devam edebilir.

---

## 6. Geri Alınamaz İşlem
Hesap silme işlemi tamamlandıktan sonra:
* Hesap geri getirilemez.
* Kullanıcı verileri kurtarılamaz.
* İçerikler geri yüklenemez.
* Abonelik hakları tekrar kullanılamaz.
Bu nedenle kullanıcıların hesap silme işlemi öncesinde gerekli yedeklemeleri yapmaları tavsiye edilir.

---

## 7. Veri Saklama Süresi
Bazı kayıtlar aşağıdaki nedenlerle belirli süre boyunca saklanabilir:
* Güvenlik kayıtları
* Hata kayıtları
* Dolandırıcılık önleme kayıtları
* Yasal yükümlülükler
* Muhasebe ve finansal kayıtlar
Bu veriler yalnızca gerekli olduğu süre boyunca muhafaza edilir.

---

## 8. Hesap Silme Talebinin Reddedilebileceği Durumlar
Aşağıdaki durumlarda hesap silme işlemi gecikebilir veya belirli verilerin silinmesi ertelenebilir:
* Devam eden yasal süreçler
* Resmi makam talepleri
* Güvenlik soruşturmaları
* Yasal saklama zorunlulukları
Bu durumlarda yalnızca ilgili mevzuat kapsamında gerekli olan veriler saklanır.

---

## 9. KVKK ve Veri Koruma Hakları
Kullanıcılar;
* Verilerine erişme,
* Verilerinin düzeltilmesini isteme,
* Verilerinin silinmesini talep etme,
* İşleme faaliyetleri hakkında bilgi alma
haklarına sahiptir. Bu haklar ilgili veri koruma mevzuatı kapsamında kullanılabilir.

---

## 10. Politika Değişiklikleri
Notiva bu Hesap Silme Politikası'nı güncelleme hakkını saklı tutar.
Güncellenen sürüm yayınlandığı tarihten itibaren yürürlüğe girer.

---

## 11. İletişim
Hesap silme işlemleri veya veri kaldırma talepleri hakkında bizimle aşağıdaki iletişim adresi üzerinden iletişime geçebilirsiniz:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek bu Hesap Silme Politikası'nı kabul etmiş sayılırsınız.*
''';

const String _gizlilik = '''
# NOTIVA GİZLİLİK POLİTİKASI

**Son Güncelleme Tarihi:** 01.07.2026

Notiva olarak kullanıcılarımızın gizliliğine ve kişisel verilerinin korunmasına önem veriyoruz. Bu Gizlilik Politikası, Notiva mobil uygulaması ve ilgili hizmetler kapsamında hangi bilgilerin toplandığını, nasıl kullanıldığını, nasıl korunduğunu ve kullanıcıların sahip olduğu hakları açıklamaktadır.

Notiva'yı kullanarak bu Gizlilik Politikası'nı okuduğunuzu ve kabul ettiğinizi beyan etmiş olursunuz.

---

## 1. Toplanan Bilgiler
Notiva, hizmetlerini sunabilmek amacıyla aşağıdaki bilgileri toplayabilir.

**Hesap Bilgileri**
* Ad ve soyad
* E-posta adresi
* Profil fotoğrafı (isteğe bağlı)
* Kullanıcı kimlik bilgileri
* Google veya Apple ile giriş bilgileri

**Kullanıcı İçerikleri**
Kullanıcı tarafından oluşturulan veya sisteme yüklenen:
* Notlar
* Görevler
* Yapılacaklar listeleri (To Do)
* Hatırlatıcılar
* Yorumlar
* Etiketler
* Şablonlar
* Ortak alan içerikleri
* Dosya ekleri

**Teknik Veriler**
* Cihaz modeli
* İşletim sistemi sürümü
* Uygulama sürümü
* Hata kayıtları
* Performans verileri
* IP adresi
* Oturum bilgileri

---

## 2. Bilgilerin Kullanım Amaçları
Toplanan bilgiler aşağıdaki amaçlarla kullanılabilir:
* Kullanıcı hesabının oluşturulması ve yönetilmesi
* Verilerin cihazlar arasında senkronize edilmesi
* Ortak çalışma alanlarının yönetilmesi
* Görev atama ve ekip yönetimi işlemlerinin yürütülmesi
* Hatırlatıcı ve bildirimlerin gönderilmesi
* Teknik destek sağlanması
* Güvenlik önlemlerinin uygulanması
* Hataların tespit edilmesi ve giderilmesi
* Uygulama performansının geliştirilmesi
* Yasal yükümlülüklerin yerine getirilmesi

---

## 3. Ortak Alanlar ve Ekip Çalışması
Notiva, kullanıcıların ortak çalışma alanları oluşturmasına ve ekip üyeleri davet etmesine olanak tanır.
Ortak alanlarda oluşturulan:
* Notlar
* Görevler
* Dosyalar
* Yorumlar
* Aktivite kayıtları
ilgili çalışma alanındaki yetkili ekip üyeleri tarafından görüntülenebilir. Kullanıcılar ortak alanlarda paylaştıkları içeriklerden sorumludur.

---

## 4. Dosya Yükleme ve Depolama
Notiva, abonelik planına bağlı olarak dosya yükleme özelliği sunabilir.
Kullanıcılar tarafından yüklenen:
* PDF dosyaları
* Görseller
* Belgeler
* Diğer desteklenen dosya türleri
uygulamanın çalışabilmesi amacıyla güvenli sunucularda saklanabilir. Yüklenen dosyaların yasal sorumluluğu kullanıcıya aittir.

---

## 5. Abonelikler ve Ödemeler
Notiva ücretli ve ücretsiz kullanım planları sunabilir. Abonelik işlemleri:
* Apple App Store
* Google Play Store
üzerinden gerçekleştirilir. Notiva, kredi kartı veya ödeme bilgilerini doğrudan saklamaz. Ödeme işlemleri ilgili uygulama mağazasının güvenli ödeme sistemleri üzerinden yürütülür.

---

## 6. Verilerin Saklanması
Kullanıcı verileri;
* Hesap aktif olduğu sürece,
* Hizmetlerin sunulabilmesi için gerekli olduğu müddetçe,
* Yasal yükümlülüklerin gerektirdiği süre boyunca
saklanabilir.

---

## 7. Hesap Silme ve Veri Silme
Kullanıcılar hesaplarını uygulama içerisinden silebilir. Hesap silme işlemi sonrasında:
* Kişisel notlar
* Görevler
* Yapılacaklar listeleri
* Hatırlatıcılar
* Dosya ekleri
* Profil bilgileri
makul süre içerisinde sistemden kaldırılır veya anonim hale getirilir. Ortak çalışma alanlarında ekip bütünlüğünü korumak amacıyla bazı kayıtlar "Silinmiş Kullanıcı" olarak görüntülenebilir.

---

## 8. Üçüncü Taraf Hizmetler
Notiva aşağıdaki üçüncü taraf hizmetlerden yararlanabilir:
* Firebase
* Google Sign-In
* Apple Sign-In
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
Bu hizmetlerin kullanımında ilgili hizmet sağlayıcılarının gizlilik politikaları da geçerli olabilir.

---

## 9. Veri Güvenliği
Notiva kullanıcı verilerini korumak amacıyla makul teknik ve idari güvenlik önlemleri uygular. Bunlar arasında:
* Kimlik doğrulama sistemleri
* Şifreleme yöntemleri
* Yetkilendirme kontrolleri
* Güvenlik güncellemeleri
yer alabilir. Ancak internet üzerinden yapılan hiçbir veri aktarımının %100 güvenli olduğu garanti edilemez.

---

## 10. Çocukların Gizliliği
Notiva, 13 yaşın altındaki bireyler için tasarlanmamıştır. 13 yaşın altındaki kullanıcıların uygulamayı ebeveyn izni olmadan kullanmaması gerekmektedir.

---

## 11. Politika Değişiklikleri
Notiva, bu Gizlilik Politikası'nı zaman zaman güncelleyebilir. Güncellenen sürüm uygulama içerisinde veya ilgili platformlarda yayınlandığı tarihten itibaren yürürlüğe girer.

---

## 12. İletişim
Bu Gizlilik Politikası ile ilgili sorularınız, talepleriniz veya veri koruma konularındaki başvurularınız için aşağıdaki iletişim adresini kullanabilirsiniz:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek bu Gizlilik Politikası'nı kabul etmiş sayılırsınız.*
''';

const String _kvkk = '''
# NOTIVA KVKK AYDINLATMA METNİ

**Son Güncelleme Tarihi:** 01.07.2026

İşbu Aydınlatma Metni, Notiva mobil uygulaması kapsamında işlenen kişisel verilere ilişkin olarak, 6698 Sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") uyarınca kullanıcıların bilgilendirilmesi amacıyla hazırlanmıştır.

Notiva'yı kullanarak bu metinde belirtilen hususlar hakkında bilgilendirildiğinizi kabul etmiş olursunuz.

---

## 1. Veri Sorumlusu
6698 Sayılı Kişisel Verilerin Korunması Kanunu kapsamında veri sorumlusu Notiva'dır.
KVKK kapsamındaki talepleriniz için aşağıdaki iletişim adresini kullanabilirsiniz:
**E-posta:** seyfullahejderha0@gmail.com

---

## 2. İşlenen Kişisel Veriler
Notiva hizmetlerinin sunulabilmesi amacıyla aşağıdaki kişisel veriler işlenebilir.

**Kimlik Bilgileri**
* Ad
* Soyad
* Kullanıcı adı

**İletişim Bilgileri**
* E-posta adresi

**Hesap Bilgileri**
* Kullanıcı kimliği
* Profil fotoğrafı (isteğe bağlı)
* Oturum bilgileri

**Kullanıcı İçerikleri**
* Notlar
* Görevler
* Yapılacaklar listeleri (To Do)
* Hatırlatıcılar
* Etiketler
* Yorumlar
* Şablonlar
* Ortak alan içerikleri
* Dosya ekleri

**Teknik Veriler**
* IP adresi
* Cihaz bilgileri
* İşletim sistemi bilgileri
* Uygulama sürümü
* Hata kayıtları
* Kullanım istatistikleri

---

## 3. Kişisel Verilerin İşlenme Amaçları
Toplanan kişisel veriler aşağıdaki amaçlarla işlenebilir:
* Kullanıcı hesabının oluşturulması
* Kimlik doğrulama işlemlerinin gerçekleştirilmesi
* Uygulama hizmetlerinin sunulması
* Verilerin cihazlar arasında senkronize edilmesi
* Ortak çalışma alanlarının yönetilmesi
* Görev atama ve ekip yönetimi süreçlerinin yürütülmesi
* Bildirim ve hatırlatmaların gönderilmesi
* Teknik destek hizmetlerinin sağlanması
* Uygulama performansının geliştirilmesi
* Güvenlik ve denetim süreçlerinin yürütülmesi
* Yasal yükümlülüklerin yerine getirilmesi

---

## 4. Kişisel Verilerin Toplanma Yöntemi
Kişisel veriler;
* Kullanıcının uygulamaya kayıt olması,
* Uygulama içerisinde içerik oluşturması,
* Dosya yüklemesi,
* Ortak alanlara katılması,
* Destek talebi oluşturması,
* Google veya Apple ile giriş yapması,
yollarıyla elektronik ortamda toplanabilir.

---

## 5. Kişisel Verilerin Aktarılması
Notiva, kullanıcı verilerini üçüncü kişilere satmaz veya ticari amaçlarla paylaşmaz.
Ancak aşağıdaki durumlarda veri aktarımı gerçekleştirilebilir:

**Hizmet Sağlayıcılar**
Uygulamanın çalışabilmesi amacıyla:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
gibi hizmet sağlayıcılardan yararlanılabilir.

**Yasal Yükümlülükler**
Yetkili kamu kurumları veya mahkemeler tarafından talep edilmesi halinde ilgili mevzuat kapsamında gerekli bilgiler paylaşılabilir.

---

## 6. Kişisel Verilerin Saklanması
Kişisel veriler;
* Hizmetin sunulabilmesi için gerekli olduğu sürece,
* Kullanıcı hesabı aktif olduğu sürece,
* Yasal yükümlülüklerin gerektirdiği süre boyunca
saklanabilir.
Bu sürelerin sona ermesi halinde veriler silinir, yok edilir veya anonim hale getirilir.

---

## 7. Hesap Silme ve Veri Silme
Kullanıcılar hesaplarını uygulama içerisinden silebilir.
Hesap silme işlemi sonrasında:
* Kişisel profil bilgileri,
* Notlar,
* Görevler,
* Yapılacaklar listeleri,
* Hatırlatıcılar,
* Dosya ekleri,
sistemden kaldırılır veya anonim hale getirilir.
Ortak alanlarda ekip çalışmalarının devamlılığını sağlamak amacıyla bazı kayıtlar "Silinmiş Kullanıcı" olarak tutulabilir.

---

## 8. KVKK Kapsamındaki Haklarınız
KVKK'nın 11. maddesi kapsamında kullanıcılar aşağıdaki haklara sahiptir:
* Kişisel veri işlenip işlenmediğini öğrenme
* İşlenen verilere ilişkin bilgi talep etme
* İşleme amacını öğrenme
* Verilerin aktarıldığı üçüncü kişileri öğrenme
* Eksik veya yanlış işlenen verilerin düzeltilmesini isteme
* Verilerin silinmesini veya yok edilmesini isteme
* İşlemenin kanuna aykırı olması halinde zararın giderilmesini talep etme

---

## 9. Veri Güvenliği
Notiva kullanıcı verilerinin korunması amacıyla gerekli teknik ve idari güvenlik tedbirlerini uygulamaktadır.
Bu kapsamda:
* Kimlik doğrulama sistemleri,
* Yetkilendirme kontrolleri,
* Güvenli veri depolama yöntemleri,
* Güncel güvenlik uygulamaları
kullanılmaktadır.
Ancak internet üzerinden yapılan veri iletimlerinin tamamen güvenli olduğu garanti edilemez.

---

## 10. Aydınlatma Metninde Değişiklik
Notiva bu Aydınlatma Metni üzerinde gerekli gördüğü değişiklikleri yapma hakkını saklı tutar.
Güncellenen metin uygulama içerisinde yayınlandığı tarihte yürürlüğe girer.

---

## 11. İletişim
KVKK kapsamındaki talepleriniz ve kişisel verilerinizle ilgili başvurularınız için aşağıdaki iletişim adresini kullanabilirsiniz:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek işbu KVKK Aydınlatma Metni kapsamında bilgilendirildiğinizi kabul etmiş olursunuz.*
''';

const String _appStorePrivacy = '''
# NOTIVA APPLE APP STORE GİZLİLİK VE VERİ KULLANIMI BİLDİRİMİ

**Son Güncelleme Tarihi:** 01.07.2026

Bu metin, Notiva uygulamasının Apple App Store üzerinden dağıtımı kapsamında kullanıcıların hangi verilerinin toplandığını, nasıl kullanıldığını ve nasıl korunduğunu açıklamak amacıyla hazırlanmıştır.

Notiva, kullanıcıların notlarını, görevlerini, yapılacaklar listelerini ve ekip çalışmalarını güvenli şekilde yönetebilmeleri için geliştirilmiş bir verimlilik uygulamasıdır.

---

## 1. Toplanan Veriler
Notiva, hizmetlerin sunulabilmesi amacıyla aşağıdaki veri kategorilerini toplayabilir.

**Hesap Bilgileri**
* Ad ve soyad
* E-posta adresi
* Profil fotoğrafı (isteğe bağlı)
* Kullanıcı kimliği

**Kullanıcı İçerikleri**
* Notlar
* Görevler
* Yapılacaklar listeleri (To Do)
* Hatırlatıcılar
* Etiketler
* Yorumlar
* Şablonlar
* Ortak çalışma alanı içerikleri
* Dosya ekleri

**Teknik Bilgiler**
* Cihaz modeli
* İşletim sistemi sürümü
* Uygulama sürümü
* Hata kayıtları
* Performans verileri
* IP adresi
* Oturum bilgileri

---

## 2. Verilerin Kullanım Amaçları
Toplanan veriler aşağıdaki amaçlarla kullanılabilir:
* Kullanıcı hesabının oluşturulması
* Kimlik doğrulama işlemlerinin yürütülmesi
* Verilerin cihazlar arasında senkronize edilmesi
* Görev ve not yönetiminin sağlanması
* Ortak çalışma alanlarının yönetilmesi
* Ekip üyeleri arasında iş birliğinin sağlanması
* Bildirim ve hatırlatmaların gönderilmesi
* Teknik destek sağlanması
* Uygulama performansının geliştirilmesi
* Güvenlik ve kötüye kullanım önleme süreçlerinin yürütülmesi

---

## 3. Takip (Tracking) Politikası
Notiva kullanıcıları reklam amaçlı takip etmez.
Notiva;
* Üçüncü taraf reklam ağları üzerinden kullanıcı profillemesi yapmaz.
* Kullanıcı verilerini reklam satışı amacıyla paylaşmaz.
* Kullanıcı davranışlarını reklam hedefleme amacıyla izlemez.
Notiva tarafından toplanan veriler yalnızca uygulamanın çalışması ve hizmetlerin sunulması amacıyla kullanılmaktadır.

---

## 4. Üçüncü Taraf Hizmet Sağlayıcılar
Notiva aşağıdaki hizmet sağlayıcılardan yararlanabilir:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
Bu hizmetler kendi gizlilik politikalarına tabi olabilir.

---

## 5. Hesap Silme Hakkı
Apple App Store gereklilikleri doğrultusunda kullanıcılar hesaplarını uygulama içerisinden silebilir.
Hesap silme işlemi:
**Profil > Ayarlar > Hesabı Kalıcı Olarak Sil**
menüsü üzerinden gerçekleştirilebilir. Hesap silme sonrasında kullanıcıya ait kişisel veriler makul süre içerisinde kaldırılır veya anonim hale getirilir.

---

## 6. Abonelikler
Notiva ücretli abonelik planları sunabilir.
Abonelik işlemleri Apple App Store üzerinden yönetilir. Kullanıcılar:
* Abonelik satın alma,
* Abonelik yenileme,
* Abonelik iptali
işlemlerini Apple kimlikleri üzerinden gerçekleştirebilir.
**Hesabın silinmesi aktif abonelikleri otomatik olarak iptal etmez.**
Abonelik iptal işlemleri App Store abonelik yönetim ekranı üzerinden ayrıca yapılmalıdır.

---

## 7. Veri Güvenliği
Notiva kullanıcı verilerini korumak amacıyla çeşitli teknik ve idari güvenlik önlemleri uygulamaktadır. Bunlar arasında:
* Kimlik doğrulama sistemleri
* Yetkilendirme mekanizmaları
* Güvenli veri depolama yöntemleri
* Güncel güvenlik uygulamaları
yer almaktadır.

---

## 8. Çocukların Gizliliği
Notiva 13 yaşın altındaki çocuklar için tasarlanmamıştır. 13 yaşın altındaki kullanıcıların uygulamayı ebeveyn gözetimi olmadan kullanmamaları gerekmektedir.

---

## 9. Veri Saklama Süresi
Kullanıcı verileri;
* Hesap aktif olduğu sürece,
* Hizmetin sunulması için gerekli olduğu müddetçe,
* Yasal yükümlülüklerin gerektirdiği süre boyunca
saklanabilir. Bu sürelerin sonunda veriler silinir veya anonim hale getirilir.

---

## 10. İletişim
Apple App Store gizlilik uygulamaları ve veri koruma süreçleri hakkında sorularınız için aşağıdaki iletişim adresi kullanılabilir:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek bu Apple App Store Gizlilik ve Veri Kullanımı Bildirimi kapsamında bilgilendirildiğinizi kabul etmiş olursunuz.*
''';

const String _googlePlayData = '''
# NOTIVA GOOGLE PLAY DATA SAFETY (VERİ GÜVENLİĞİ) METNİ

**Son Güncelleme Tarihi:** 01.07.2026

Bu Veri Güvenliği Metni, Notiva uygulamasının Google Play Store Veri Güvenliği Politikaları kapsamında kullanıcıların hangi verilerinin toplandığını, nasıl işlendiğini, nasıl korunduğunu ve hangi amaçlarla kullanıldığını açıklamak amacıyla hazırlanmıştır.

Notiva, kullanıcıların notlarını, görevlerini, yapılacaklar listelerini, hatırlatıcılarını ve ekip çalışmalarını güvenli şekilde yönetebilmeleri için geliştirilmiş bir verimlilik ve iş birliği platformudur.

---

## 1. Toplanan Veri Türleri
Notiva aşağıdaki veri kategorilerini işleyebilir.

**Hesap Bilgileri**
* Ad ve soyad
* E-posta adresi
* Profil fotoğrafı (isteğe bağlı)
* Kullanıcı kimliği

**Kullanım Amacı:**
* Hesap oluşturma
* Kimlik doğrulama
* Hesap yönetimi
* Kullanıcı desteği

---

**Kullanıcı Tarafından Oluşturulan İçerikler**
Notiva içerisinde oluşturulan:
* Notlar
* Görevler
* Yapılacaklar listeleri (To Do)
* Hatırlatıcılar
* Yorumlar
* Etiketler
* Şablonlar
* Ortak çalışma alanı içerikleri
* Dosya ekleri

**Kullanım Amacı:**
* Hizmetlerin sunulması
* Verilerin senkronize edilmesi
* Ekip iş birliğinin sağlanması
* Kullanıcı taleplerinin yerine getirilmesi

---

**Teknik ve Cihaz Bilgileri**
* Cihaz modeli
* İşletim sistemi sürümü
* Uygulama sürümü
* IP adresi
* Hata kayıtları
* Performans verileri
* Oturum bilgileri

**Kullanım Amacı:**
* Güvenlik
* Performans iyileştirmeleri
* Hata tespiti
* Teknik destek

---

## 2. Veriler Paylaşılıyor Mu?
Notiva kullanıcı verilerini satmaz. Kullanıcı verileri reklam amaçlı üçüncü taraflarla paylaşılmaz.
Ancak uygulamanın çalışabilmesi amacıyla aşağıdaki hizmet sağlayıcılarla veri paylaşımı yapılabilir:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
Bu hizmet sağlayıcılar yalnızca hizmet sunumunun gerçekleştirilebilmesi amacıyla kullanılmaktadır.

---

## 3. Veriler Şifreleniyor Mu?
Evet. Notiva tarafından işlenen veriler:
* Aktarım sırasında
* Depolama süreçlerinde
güvenli bağlantılar ve ilgili güvenlik mekanizmaları kullanılarak korunmaktadır.

---

## 4. Kullanıcı Verilerini Silebilir Mi?
Evet. Kullanıcılar hesaplarını uygulama içerisinden silebilirler.
Hesap silme işlemi:
**Profil > Ayarlar > Hesabımı Kalıcı Olarak Sil**
menüsü üzerinden gerçekleştirilebilir.
Hesap silme işlemi sonrasında:
* Kişisel profil bilgileri
* Kişisel notlar
* Görevler
* Yapılacaklar listeleri
* Hatırlatıcılar
* Dosya ekleri
sistemden kaldırılır veya anonim hale getirilir.

---

## 5. Ortak Alanlar ve Ekip Verileri
Notiva ekip çalışmasını destekleyen ortak çalışma alanları sunmaktadır.
Kullanıcının ortak çalışma alanlarında oluşturduğu bazı kayıtlar:
* Görev geçmişleri
* Aktivite kayıtları
* Yorum geçmişleri
ekip bütünlüğünün korunması amacıyla anonim hale getirilerek saklanabilir.
Bu durumda kullanıcı adı yerine **"Silinmiş Kullanıcı"** ifadesi gösterilebilir.

---

## 6. Reklam ve Takip Politikası
Notiva:
* Kullanıcıları reklam amaçlı takip etmez.
* Üçüncü taraf reklam ağlarına kullanıcı verisi satmaz.
* Reklam profili oluşturmaz.
* Davranışsal reklam hedeflemesi yapmaz.
Toplanan veriler yalnızca hizmet sunumu ve güvenlik amaçlarıyla kullanılmaktadır.

---

## 7. Çocukların Gizliliği
Notiva 13 yaşın altındaki çocuklar için tasarlanmamıştır. 13 yaşın altındaki bireylerin uygulamayı ebeveyn izni olmaksızın kullanmamaları gerekmektedir.

---

## 8. Abonelikler ve Ödemeler
Notiva ücretsiz ve ücretli abonelik planları sunabilir.
Abonelik işlemleri Google Play Store üzerinden yönetilir. Notiva kullanıcıların ödeme kartı bilgilerini saklamaz. Tüm ödeme işlemleri Google Play Store altyapısı üzerinden gerçekleştirilir.

---

## 9. Veri Saklama Süresi
Veriler:
* Kullanıcı hesabı aktif olduğu sürece,
* Hizmetlerin sunulabilmesi için gerekli olduğu müddetçe,
* Yasal yükümlülüklerin gerektirdiği süre boyunca
saklanabilir.
Bu sürelerin sona ermesi halinde veriler silinir veya anonim hale getirilir.

---

## 10. Veri Güvenliği
Notiva kullanıcı verilerinin korunması amacıyla çeşitli güvenlik önlemleri uygular. Bu önlemler arasında:
* Kimlik doğrulama sistemleri
* Yetkilendirme kontrolleri
* Güvenli veri depolama yöntemleri
* Güncel güvenlik politikaları
yer almaktadır. Ancak internet üzerinden gerçekleştirilen hiçbir veri aktarımının %100 güvenli olduğu garanti edilemez.

---

## 11. Politika Değişiklikleri
Notiva bu Veri Güvenliği Metni üzerinde zaman zaman güncelleme yapabilir. Güncellenen sürüm yayınlandığı tarihten itibaren yürürlüğe girer.

---

## 12. İletişim
Google Play Veri Güvenliği politikaları ve kişisel verileriniz ile ilgili sorularınız için aşağıdaki iletişim adresini kullanabilirsiniz:
**Destek E-posta Adresi:** seyfullahejderha0@gmail.com

---
*Notiva'yı kullanmaya devam ederek bu Google Play Veri Güvenliği Metni kapsamında bilgilendirildiğinizi kabul etmiş olursunuz.*
''';

// --- ENGLISH TRANSLATIONS ---

const String _kullanimKosullari_en = '''
# NOTIVA TERMS OF USE

**Last Update Date:** 01.07.2026

These Terms of Use set out the rules for the use of the Notiva mobile application and related services. By downloading, registering or continuing to use Notiva, you are deemed to have accepted the following terms.

If you do not accept these terms, you should not use the application.

---

## 1. Service Description
Notiva;
* Create notes
* Task management
* Creating to-do lists
* Set a reminder
* Calendar management
* Creating Kanban boards
* Team management
* Creating shared workspaces
* File sharing
It is a digital platform that offers productivity and collaboration services such as.

---

## 2. Creating an Account
You may need to create a user account to benefit from Notiva services.
User;
* By providing accurate and up-to-date information,
* Protecting account security,
* Not sharing your password with third parties
is responsible. The account owner is responsible for the transactions carried out in the user account.

---

## 3. User Responsibilities
Notiva users:
* To act in accordance with the laws in force,
* Not to violate the rights of others,
* Not to abuse the application,
* Not to share misleading or harmful content
accepts.

---

## 4. Prohibited Uses
The following activities are strictly prohibited:
* Sharing illegal content
* Installing or distributing malware
* Attempts to violate system security
* Unauthorized access attempts
* Spam or bulk sharing of unwanted content
* Attempting to access other users' accounts
* Sharing content that violates intellectual property rights

Notiva reserves the right to suspend or permanently close accounts in such cases.

---

## 5. Common Areas and Team Use
Notiva users can create collaborative workspaces and invite team members.
Created in common areas:
* Notes
* Missions
* Files
* Comments
* Activity records
can be viewed by authorized users in the relevant work area. Responsibility for content shared in public areas belongs to the content owner.

---

## 6. Subscription Plans
Notiva may offer free and paid subscription plans. Plan contents and prices may be updated over time.
Paid plans may include the following sample features:
* Unlimited usage rights
* Co-working spaces
* File upload
* Team management
* Advanced features
Plan details are also shown within the application.

---

## 7. Payments and Subscription Renewals
Subscription purchases:
* Apple App Store
* Google Play Store
is carried out via . Subscriptions can be automatically renewed by the relevant store.
Subscription cancellation must be made by the user through the relevant store account. Notiva is not directly responsible for payment transactions carried out by the store.

---

## 8. Delete Account
Users can delete their accounts from within the application whenever they want.
After account deletion:
* Account information
* Personal notes
* Missions
* To-do lists
* Reminders
can be removed from the system or made anonymous. Account deletion cannot be undone.

---

## 9. Intellectual Property Rights
Notiva application, design, logo, software, brand elements and content are protected under the relevant intellectual property legislation.
Users may not use any part of Notiva:
* Cannot copy,
* Cannot reproduce,
* Cannot sell,
* Cannot rent,
* Cannot do reverse engineering,
or use for commercial purposes.

---

## 10. Changes to the Service
Notiva;
* Adding new features,
* Feature removal,
* Changing services,
* Termination of service temporarily or permanently
reserves the right.

---

## 11. Limit of Liability
Notiva;
* From content created by users,
* Disputes between users,
* Interruptions caused by third-party service providers,
* Internet connection or device related problems
cannot be held responsible. Users use the application at their own risk.

---

## 12. Account Suspension and Termination
Notiva may temporarily or permanently close user accounts in the following cases:
* Violation of terms of use
* Illegal activities
* Behaviors that threaten system security
* Violation of other users' rights
In this case, advance notification is not required.

---

## 13. Changes to Terms of Use
Notiva reserves the right to update these Terms of Use.
Updated terms come into force from the date of publication.
Users' continued use of the application means acceptance of the updated terms.

---

## 14. Communication
For your questions regarding the Terms of Use, the following contact address can be used:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you are deemed to have accepted these Terms of Use.*
''';

const String _hesapSilme_en = '''
# NOTIVA ACCOUNT DELETION POLICY

**Last Update Date:** 01.07.2026

This Account Deletion Policy explains how Notiva users can delete their accounts, what data will be removed after account deletion, and in what cases some records may be retained.

Notiva allows users to easily delete their accounts from within the application.

---

## 1. Right to Delete Account
All Notiva users can delete their accounts at any time without giving any reason. Account deletion can be done from within the application.
Process steps:
**Profile > Settings > Permanently Delete My Account**

---

## 2. Results of Account Deletion
When the account deletion process is completed, the user's personal data and content begin to be removed from the system. Among them:
* Profile information
* Name and surname information
* Profile photo
* Email address
* Personal notes
* Personal missions
* To-do lists (To Do)
* Reminders
* Tags
* Personal file attachments
* Personal work areas
may take place.

---

## 3. Common Areas and Team Data
Notiva offers co-working spaces that support teamwork.
If a user deletes an account:
* Tasks created in common areas,
* Comments made in common areas,
* Activity records,
* Content that may affect teamwork
can be kept in the system to protect team integrity.
In these cases, user information may be anonymized and relevant content may be displayed as **"Deleted User"**.

---

## 4. Files and Attachments
Personal files uploaded by the user are removed from the system after account deletion.
Files uploaded to common areas and required for the continuity of team work can remain accessible to the relevant workspace administrator.

---

## 5. Important Information About Subscriptions
Notiva subscriptions:
* Apple App Store
* Google Play Store
It is managed through.

**Deleting the account does not automatically cancel active subscriptions.**
Users are also obliged to cancel their subscriptions through the relevant store account. Otherwise, subscription renewals may continue by the store.

---

## 6. Irrevocable Transaction
After the account deletion process is completed:
* The account cannot be restored.
* User data cannot be recovered.
* Contents cannot be restored.
* Subscription rights cannot be reused.
For this reason, users are recommended to make necessary backups before deleting their account.

---

## 7. Data Retention Period
Some records may be retained for a certain period of time for the following reasons:
* Security records
* Error logs
* Anti-fraud records
* Legal obligations
* Accounting and financial records
This data is retained only for as long as necessary.

---

## 8. Situations Where Account Deletion Request May Be Rejected
Account deletion may be delayed or deletion of certain data may be postponed in the following cases:
* Ongoing legal processes
* Official authority requests
* Security investigations
* Legal storage obligations
In these cases, only the data required under the relevant legislation is stored.

---

## 9. KVKK and Data Protection Rights
Users;
* Accessing your data,
* Requesting correction of your data,
* Requesting the deletion of your data,
* Receive information about processing activities
has the rights. These rights may be exercised under relevant data protection legislation.

---

## 10. Policy Changes
Notiva reserves the right to update this Account Deletion Policy.
The updated version takes effect from the date of publication.

---

## 11. Communication
You can contact us regarding account deletions or data removal requests via the following contact address:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you are deemed to have accepted this Account Deletion Policy.*
''';

const String _gizlilik_en = '''
# NOTIVA PRIVACY POLICY

**Last Update Date:** 01.07.2026

As Notiva, we attach importance to the privacy of our users and the protection of their personal data. This Privacy Policy explains what information is collected within the scope of the Notiva mobile application and related services, how it is used, how it is protected and the rights that users have.

By using Notiva, you acknowledge that you have read and accepted this Privacy Policy.

---

## 1. Information Collected
Notiva may collect the following information in order to provide its services.

**Account Information**
* Name and surname
* Email address
* Profile photo (optional)
* User credentials
* Login information with Google or Apple

**User Content**
User created or uploaded to the system:
* Notes
* Missions
* To-do lists (To Do)
* Reminders
* Comments
* Tags
* Templates
* Common area contents
* File attachments

**Technical Data**
* Device model
* Operating system version
* App version
* Error logs
* Performance data
* IP address
* Session information

---

## 2. Purposes of Use of Information
The information collected may be used for the following purposes:
* Creating and managing user accounts
* Synchronization of data between devices
* Managing common work areas
* Carrying out task assignment and team management processes
* Sending reminders and notifications
* Providing technical support
* Implementation of security measures
* Detecting and fixing errors
* Improving application performance
* Fulfillment of legal obligations

---

## 3. Common Areas and Teamwork
Notiva allows users to create collaborative workspaces and invite team members.
Created in common areas:
* Notes
* Missions
* Files
* Comments
* Activity records
can be viewed by authorized team members in the relevant work area. Users are responsible for the content they share in public areas.

---

## 4. File Upload and Storage
Notiva may offer a file upload feature depending on the subscription plan.
Uploaded by users:
* PDF files
* Images
* Documents
* Other supported file types
It can be stored on secure servers so that the application can run. Legal responsibility for uploaded files belongs to the user.

---

## 5. Subscriptions and Payments
Notiva may offer paid and free usage plans. Subscription transactions:
* Apple App Store
* Google Play Store
is carried out via . Notiva does not directly store credit card or payment information. Payment transactions are carried out through the secure payment systems of the relevant application store.

---

## 6. Storage of Data
User data;
* As long as the account is active,
* As long as it is necessary to provide the services,
* During the period required by legal obligations
can be stored.

---

## 7. Account Deletion and Data Deletion
Users can delete their accounts from within the application. After account deletion:
* Personal notes
* Missions
* To-do lists
* Reminders
* File attachments
* Profile information
It is removed from the system or made anonymous within a reasonable period of time. To maintain team integrity in collaborative workspaces, some records may appear as "Deleted User".

---

## 8. Third Party Services
Notiva may use the following third-party services:
*Firebase
* Google Sign-In
* Apple Sign-In
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
The privacy policies of the relevant service providers may also apply when using these services.

---

## 9. Data Security
Notiva implements reasonable technical and administrative security measures to protect user data. Among them:
* Authentication systems
* Encryption methods
* Authorization checks
* Security updates
may take place. However, no data transmission over the internet can be guaranteed to be 100% secure.

---

## 10. Children's Privacy
Notiva is not intended for individuals under the age of 13. Users under the age of 13 should not use the application without parental permission.

---

## 11. Policy Changes
Notiva may update this Privacy Policy from time to time. The updated version comes into force from the date it is published in the application or on the relevant platforms.

---

## 12. Communication
You can use the following contact address for your questions, requests regarding this Privacy Policy or applications regarding data protection issues:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you are deemed to have accepted this Privacy Policy.*
''';

const String _kvkk_en = '''
# NOTIVA KVKK CLARIFICATION TEXT

**Last Update Date:** 01.07.2026

This Information Text has been prepared to inform users in accordance with the Personal Data Protection Law No. 6698 ("KVKK") regarding the personal data processed within the scope of the Notiva mobile application.

By using Notiva, you acknowledge that you have been informed about the matters stated in this text.

---

## 1. Data Controller
Within the scope of the Personal Data Protection Law No. 6698, the data controller is Notiva.
You can use the following contact address for your requests within the scope of KVKK:
**Email:** seyfullahejderha0@gmail.com

---

## 2. Processed Personal Data
The following personal data may be processed in order to provide Notiva services.

**Identity Information**
* Name
* Surname
* Username

**Contact Information**
* Email address

**Account Information**
* User ID
* Profile photo (optional)
* Session information

**User Content**
* Notes
* Missions
* To-do lists (To Do)
* Reminders
* Tags
* Comments
* Templates
* Common area contents
* File attachments

**Technical Data**
* IP address
* Device information
* Operating system information
* App version
* Error logs
* Usage statistics

---

## 3. Purposes of Processing Personal Data
Collected personal data may be processed for the following purposes:
* Creating a user account
* Performing authentication procedures
* Providing application services
* Synchronization of data between devices
* Managing common work areas
* Carrying out task assignment and team management processes
* Sending notifications and reminders
* Providing technical support services
* Improving application performance
* Execution of security and audit processes
* Fulfillment of legal obligations

---

## 4. Method of Collection of Personal Data
Personal data;
* The user registers to the application,
* Creating content within the application,
* File upload,
* Participation in common areas,
* Creating a support request,
* Login with Google or Apple,
It can be collected electronically via.

---

## 5. Transfer of Personal Data
Notiva does not sell user data to third parties or share it for commercial purposes.
However, data transfer can only be performed in the following cases:

**Service Providers**
In order for the application to work:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
Service providers such as can be used.

**Legal Obligations**
If requested by authorized public institutions or courts, necessary information can be shared within the scope of the relevant legislation.

---

## 6. Storage of Personal Data
Personal data;
* As long as it is necessary to provide the service,
* As long as the user account is active,
* During the period required by legal obligations
can be stored.
If these periods expire, the data is deleted, destroyed or anonymized.

---

## 7. Account Deletion and Data Deletion
Users can delete their accounts from within the application.
After account deletion:
* Personal profile information,
* Notes,
* Missions,
* To-do lists,
* Reminders,
* File attachments,
is removed from the system or made anonymous.
In order to ensure continuity of teamwork in common areas, some records may be kept as "Deleted User".

---

## 8. Your Rights Under KVKK
Within the scope of Article 11 of KVKK, users have the following rights:
* Learning whether personal data is processed or not
* Request information regarding processed data
* Learning the purpose of processing
* Learning the third parties to whom data is transferred
* Request correction of incomplete or incorrectly processed data
* Request deletion or destruction of data
* Request compensation for damages if the processing is against the law

---

## 9. Data Security
Notiva implements the necessary technical and administrative security measures to protect user data.
In this context:
* Authentication systems,
* Authorization checks,
* Secure data storage methods,
* Current security applications
is used.
However, data transmissions over the internet cannot be guaranteed to be completely secure.

---

## 10. Change in Information Text
Notiva reserves the right to make changes to this Information Text as it deems necessary.
The updated text comes into force on the date it is published in the application.

---

## 11. Communication
You can use the following contact address for your requests within the scope of KVKK and applications regarding your personal data:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you accept that you have been informed within the scope of this KVKK Information Text.*
''';

const String _appStorePrivacy_en = '''
# NOTIVA APPLE APP STORE PRIVACY AND DATA USE NOTICE

**Last Update Date:** 01.07.2026

This text has been prepared to explain which users' data is collected, how it is used and how it is protected within the scope of distribution of the Notiva application through the Apple App Store.

Notiva is a productivity application developed for users to securely manage their notes, tasks, to-do lists and teamwork.

---

## 1. Collected Data
Notiva may collect the following categories of data in order to provide services.

**Account Information**
* Name and surname
* Email address
* Profile photo (optional)
* User ID

**User Content**
* Notes
* Missions
* To-do lists (To Do)
* Reminders
* Tags
* Comments
* Templates
* Collaborative workspace contents
* File attachments

**Technical Information**
* Device model
* Operating system version
* App version
* Error logs
* Performance data
* IP address
* Session information

---

## 2. Purposes of Use of the Data
The data collected may be used for the following purposes:
* Creating a user account
* Carrying out authentication procedures
* Synchronization of data between devices
* Providing task and note management
* Managing common work areas
* Ensuring cooperation among team members
* Sending notifications and reminders
* Providing technical support
* Improving application performance
* Carrying out security and abuse prevention processes

---

## 3. Tracking Policy
Notiva does not track users for advertising purposes.
Notiva;
* It does not perform user profiling through third-party advertising networks.
* Does not share user data for advertising sales purposes.
* Does not track user behavior for ad targeting purposes.
The data collected by Notiva is used solely for the operation of the application and the provision of services.

---

## 4. Third Party Service Providers
Notiva can use the following service providers:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
These services may be subject to their own privacy policies.

---

## 5. Right to Delete Account
In accordance with Apple App Store requirements, users can delete their accounts from within the application.
Account deletion process:
**Profile > Settings > Permanently Delete Account**
can be performed via the menu. After account deletion, the user's personal data is removed or anonymized within a reasonable period of time.

---

## 6. Subscriptions
Notiva may offer paid subscription plans.
Subscription transactions are managed through the Apple App Store. Users:
* Purchasing subscriptions,
* Subscription renewal,
* Subscription cancellation
can perform their transactions through their Apple IDs.
**Deleting the account does not automatically cancel active subscriptions.**
Subscription cancellations must be made separately via the App Store subscription management screen.

---

## 7. Data Security
Notiva implements various technical and administrative security measures to protect user data. Among them:
* Authentication systems
* Authorization mechanisms
* Secure data storage methods
* Current security applications
is located.

---

## 8. Children's Privacy
Notiva is not intended for children under 13 years of age. Users under the age of 13 should not use the application without parental supervision.

---

## 9. Data Retention Period
User data;
* As long as the account is active,
* As long as it is necessary to provide the service,
* During the period required by legal obligations
can be stored. At the end of these periods, the data is deleted or anonymized.

---

## 10. Communication
For questions about Apple App Store privacy practices and data protection processes, the following contact address can be used:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you acknowledge that you have been informed in accordance with this Apple App Store Privacy and Data Use Notice.*
''';

const String _googlePlayData_en = '''
# NOTIVA GOOGLE PLAY DATA SAFETY TEXT

**Last Update Date:** 01.07.2026

This Data Security Text has been prepared to explain which users' data is collected, how it is processed, how it is protected and for what purposes it is used within the scope of Notiva application's Google Play Store Data Security Policies.

Notiva is a productivity and collaboration platform developed for users to securely manage their notes, tasks, to-do lists, reminders and teamwork.

---

## 1. Types of Data Collected
Notiva may process the following categories of data.

**Account Information**
* Name and surname
* Email address
* Profile photo (optional)
* User ID

**Intended Use:**
* Account creation
* Authentication
* Account management
* User support

---

**User Generated Content**
Created in Notiva:
* Notes
* Missions
* To-do lists (To Do)
* Reminders
* Comments
* Tags
* Templates
* Collaborative workspace contents
* File attachments

**Intended Use:**
* Providing services
* Synchronization of data
* Ensuring team cooperation
* Fulfilling user requests

---

**Technical and Device Information**
* Device model
* Operating system version
* App version
* IP address
* Error logs
* Performance data
* Session information

**Intended Use:**
* Security
* Performance improvements
* Error detection
* Technical support

---

## 2. Is Data Shared?
Notiva does not sell user data. User data is not shared with third parties for advertising purposes.
However, in order for the application to work, data may be shared with the following service providers:
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In
* Apple Sign-In
These service providers are used solely for the purpose of providing services.

---

## 3. Is Data Encrypted?
Yes. Data processed by Notiva:
* During transfer
* In storage processes
It is protected using secure connections and relevant security mechanisms.

---

## 4. Can the User Delete Their Data?
Yes. Users can delete their accounts from within the application.
Account deletion process:
**Profile > Settings > Permanently Delete My Account**
can be performed via the menu.
After account deletion:
* Personal profile information
* Personal notes
* Missions
* To-do lists
* Reminders
* File attachments
is removed from the system or made anonymous.

---

## 5. Common Areas and Team Data
Notiva offers co-working spaces that support teamwork.
Some records that the user creates in collaborative workspaces:
* Mission histories
* Activity records
* Comment histories
It can be anonymized and stored to protect team integrity.
In this case, **"Deleted User"** may be displayed instead of the username.

---
## 6. Advertising and Tracking Policy
Notiva:
* It does not track users for advertising purposes.
* Does not sell user data to third-party ad networks.
* It does not create an advertising profile.
* Does not do behavioral ad targeting.
The data collected is used solely for service delivery and security purposes.

---

## 7. Children's Privacy
Notiva is not intended for children under 13 years of age. Individuals under the age of 13 should not use the application without parental permission.

---

## 8. Subscriptions and Payments
Notiva may offer free and paid subscription plans.
Subscription transactions are managed through Google Play Store. Notiva does not store users' payment card information. All payment transactions are carried out through the Google Play Store infrastructure.

---

## 9. Data Retention Period
Data:
* As long as the user account is active,
* As long as it is necessary to provide the services,
* During the period required by legal obligations
can be stored.
If these periods expire, the data is deleted or anonymized.

---

## 10. Data Security
Notiva implements various security measures to protect user data. Among these measures:
* Authentication systems
* Authorization checks
* Secure data storage methods
* Current security policies
is located. However, no data transmission over the internet can be guaranteed to be 100% secure.

---

## 11. Policy Changes
Notiva may update this Data Security Text from time to time. The updated version takes effect from the date of publication.

---

## 12. Communication
You can use the following contact address for your questions regarding Google Play Data Security policies and your personal data:
**Support Email Address:** seyfullahejderha0@gmail.com

---
*By continuing to use Notiva, you acknowledge that you have been informed within the scope of this Google Play Data Security Statement.*
''';
