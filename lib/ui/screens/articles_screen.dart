import 'package:fuzzy/fuzzy.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../l10n/app_localizations.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late Future<List<Category>> _futureCategories;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  late Fuzzy<Category> _fuzzy;
  List<Category> _all = [];

  @override
  void initState() {
    super.initState();
    _futureCategories = context.read<CategoryRepository>().getAllCategories();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _futureCategories,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data!;
        if (_all.isEmpty) {
          _all = data;
          _fuzzy = Fuzzy<Category>(
            _all,
            options: FuzzyOptions(
              keys: [
                WeightedKey<Category>(
                  name: 'name',
                  getter: (c) => c.name,
                  weight: 1,
                ),
              ],
              threshold: 0.4,
            ),
          );
        }

        final filtered =
            _query.isEmpty
                ? _all
                : _fuzzy.search(_query).map((result) => result.item).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.findArticle,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final cat = filtered[i];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        cat.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    title: Text(cat.name),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
