import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: const LoadingDemoPage(),
    );
  }
}

class LoadingDemoPage extends StatefulWidget {
  const LoadingDemoPage({super.key});

  @override
  State<LoadingDemoPage> createState() => _LoadingDemoPageState();
}

class _LoadingDemoPageState extends State<LoadingDemoPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startLoading() {
    setState(() => _isLoading = true);

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading States Comparison', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: Colors.deepPurple,
            child: TabBar(
              onTap: _isLoading ? (_) {} : null,
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [
                Tab(icon: Icon(Icons.refresh, size: 20), text: 'Circular Progress'),
                Tab(icon: Icon(Icons.auto_awesome, size: 20), text: 'Shimmer Effect'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(controller: _tabController, children: [_buildCircularProgressTab(), _buildShimmerTab()]),
          ),
          _buildLoadButton(),
        ],
      ),
    );
  }

  // ---------- LOAD BUTTON ----------
  Widget _buildLoadButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _startLoading,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade500,
              elevation: _isLoading ? 0 : 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade500),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Loading Data...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 22),
                      SizedBox(width: 8),
                      Text('Load Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ---------- CIRCULAR PROGRESS TAB ----------
  Widget _buildCircularProgressTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _isLoading ? _buildCircularProgressLoading() : _buildContent(),
    );
  }

  Widget _buildCircularProgressLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 4, color: Colors.deepPurple),
          const SizedBox(height: 32),
          Text(
            'Loading your data...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text('Please wait a moment', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  // ---------- SHIMMER TAB ----------
  Widget _buildShimmerTab() {
    return Padding(padding: const EdgeInsets.all(20), child: _isLoading ? _buildShimmerList() : _buildContent());
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          period: const Duration(milliseconds: 1500),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 14,
                        width: 180,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- LOADED CONTENT ----------
  Widget _buildContent() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        final colors = [Colors.deepPurple, Colors.blue, Colors.teal, Colors.orange];
        final color = colors[index % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(Icons.person_rounded, color: color, size: 28),
            ),
            title: Text('Alex Johnson ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Senior Product Designer', style: TextStyle(fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text('Available', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey.shade400),
          ),
        );
      },
    );
  }
}
