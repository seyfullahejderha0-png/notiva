import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/l10n/app_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../shared/services/subscription_service.dart';
import '../../../core/theme/theme_ext.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isLoading = true;
  bool _isYearly = false;
  List<ProductDetails> _packages = [];

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final service = ref.read(subscriptionServiceProvider);
    final packages = await service.getOfferings();
    setState(() {
      _packages = packages;
      _isLoading = false;
    });
  }

  Future<void> _purchase(ProductDetails package) async {
    setState(() => _isLoading = true);
    final service = ref.read(subscriptionServiceProvider);
    final success = await service.purchasePackage(package);
    setState(() => _isLoading = false);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.subscriptionActivated)),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.subscriptionCancelled)),
      );
    }
  }

  // Feature map generator based on identifier
  List<String> _getFeatures(BuildContext context, String identifier) {
    final l10n = AppLocalizations.of(context)!;
    if (identifier.contains('basic')) {
      return [l10n.unlimitedNotes, l10n.storage100mb, l10n.teamCapacity3, l10n.workspace1];
    } else if (identifier.contains('pro')) {
      return [l10n.unlimitedNotes, l10n.storage1gb, l10n.teamCapacity10, l10n.advancedReminders];
    } else if (identifier.contains('enterprise')) {
      return [l10n.unlimitedNotes, l10n.storage5gb, l10n.teamCapacity50, l10n.workspace2, l10n.prioritySupport];
    } else if (identifier.contains('workspace')) {
      return ['+1 Ekstra Ortak Çalışma Alanı', 'Tüm ekipleriniz için geçerli'];
    } else if (identifier.contains('storage')) {
      return ['+1 GB Ekstra Depolama Alanı', 'Dosya ve medya sınırını artırın'];
    }
    return ['Sınırsız Kullanım ve Öncelikli Destek'];
  }

  Color _getCardColor(String identifier) {
    if (identifier.contains('basic')) return const Color(0xFF4ADE80);
    if (identifier.contains('pro')) return const Color(0xFF60A5FA);
    if (identifier.contains('enterprise')) return const Color(0xFFA78BFA);
    return const Color(0xFFFBBF24); // Add-ons
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.subscriptionTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.bgBackground, context.bgBackground.withOpacity(0.8), Colors.blue.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  Text(
                    AppLocalizations.of(context)!.subscriptionSubtitle,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.subscriptionDesc,
                    style: TextStyle(fontSize: 16, color: context.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildToggle(),
                  const SizedBox(height: 30),
                  if (_packages.isEmpty)
                    ..._buildMockPackages(context)
                  else
                    ..._getFilteredPackages().map((pkg) => _buildPackageCard(
                          context,
                          title: pkg.title,
                          identifier: pkg.id,
                          price: pkg.price,
                          onTap: () => _purchase(pkg),
                        )),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: context.bgSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !_isYearly ? Colors.blueAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: !_isYearly ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8)] : null,
                ),
                child: Text(
                  'Aylık',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: !_isYearly ? Colors.white : context.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _isYearly ? Colors.blueAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: _isYearly ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8)] : null,
                ),
                child: Text(
                  'Yıllık (3 Ay Bizden)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _isYearly ? Colors.white : context.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ProductDetails> _getFilteredPackages() {
    return _packages.where((pkg) {
      if (_isYearly) {
        return pkg.id.toLowerCase().contains('yillik');
      } else {
        return pkg.id.toLowerCase().contains('aylik') || !pkg.id.toLowerCase().contains('yillik');
      }
    }).toList();
  }

  Widget _buildPackageCard(BuildContext context, {
    required String title,
    required String identifier,
    required String price,
    required VoidCallback onTap,
  }) {
    final features = _getFeatures(context, identifier.toLowerCase());
    final accentColor = _getCardColor(identifier.toLowerCase());

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.bgSurface.withOpacity(0.8),
              border: Border.all(color: accentColor.withOpacity(0.4), width: 1.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title.replaceAll('(Notiva)', '').trim(),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Icon(Icons.workspace_premium_rounded, color: accentColor, size: 36),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: accentColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(Icons.check_rounded, size: 16, color: accentColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Text(f, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      '$price ${AppLocalizations.of(context)!.selectPlan}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMockPackages(BuildContext context) {
    if (_isYearly) {
      return [
        _buildPackageCard(
          context,
          title: AppLocalizations.of(context)!.basicPlan,
          identifier: 'basic',
          price: '₺499.99 / yıl',
          onTap: () => _showMockSnack(),
        ),
        _buildPackageCard(
          context,
          title: AppLocalizations.of(context)!.proPlan,
          identifier: 'pro',
          price: '₺999.99 / yıl',
          onTap: () => _showMockSnack(),
        ),
        _buildPackageCard(
          context,
          title: AppLocalizations.of(context)!.enterprisePlan,
          identifier: 'enterprise',
          price: '₺4999.99 / yıl',
          onTap: () => _showMockSnack(),
        ),
        _buildPackageCard(
          context,
          title: '+1 Çalışma Alanı',
          identifier: 'workspace',
          price: '₺199.99 / yıl',
          onTap: () => _showMockSnack(),
        ),
        _buildPackageCard(
          context,
          title: '+1 GB Depolama',
          identifier: 'storage',
          price: '₺99.99 / yıl',
          onTap: () => _showMockSnack(),
        ),
      ];
    }
    return [
      _buildPackageCard(
        context,
        title: AppLocalizations.of(context)!.basicPlan,
        identifier: 'basic',
        price: '₺49.99 / ay',
        onTap: () => _showMockSnack(),
      ),
      _buildPackageCard(
        context,
        title: AppLocalizations.of(context)!.proPlan,
        identifier: 'pro',
        price: '₺99.99 / ay',
        onTap: () => _showMockSnack(),
      ),
      _buildPackageCard(
        context,
        title: AppLocalizations.of(context)!.enterprisePlan,
        identifier: 'enterprise',
        price: '₺499.99 / ay',
        onTap: () => _showMockSnack(),
      ),
      _buildPackageCard(
        context,
        title: '+1 Çalışma Alanı',
        identifier: 'workspace',
        price: '₺19.99 / ay',
        onTap: () => _showMockSnack(),
      ),
      _buildPackageCard(
        context,
        title: '+1 GB Depolama',
        identifier: 'storage',
        price: '₺9.99 / ay',
        onTap: () => _showMockSnack(),
      ),
    ];
  }

  void _showMockSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bu bir test görünümüdür. Play Store\'a yüklendiğinde aktif olacaktır.')),
    );
  }
}
