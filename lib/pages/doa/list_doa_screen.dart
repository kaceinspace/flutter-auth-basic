import 'package:flutter/material.dart';
import 'package:xii_rpl_3/models/doa_model.dart';
import 'package:xii_rpl_3/pages/posts/detail_posts_screen.dart';
import 'package:xii_rpl_3/models/album_model.dart';
import 'package:xii_rpl_3/services/album_service.dart';
import 'package:xii_rpl_3/services/doa_service.dart';

class ListDoaScreen extends StatelessWidget {
  const ListDoaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.amber,
      child: FutureBuilder<List<DoaModel>>(
        future: DoaService.listAlbum(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dataDoa = snapshot.data ?? [];
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: dataDoa.length,
            itemBuilder: (context, items) {
              final data = dataDoa[items];
              return GestureDetector(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => AlbumDetailScreen(
                //         id: data.id.toString(),
                //         title: data.title,
                //         userId: data.userId.toString(),
                //       ),
                //     ),
                //   );
                // },
                child: ListTile(
                  leading: Text(data.id.toString()),
                  title: Text(data.doa),
                  subtitle: Text('User ID: ${data.latin}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
