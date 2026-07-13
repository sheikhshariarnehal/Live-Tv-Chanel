'use client';

import React, { useState, useEffect, useRef } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import { Plus, Edit2, Trash2, Save, X, Search, Layers, GripVertical, AlertCircle } from 'lucide-react';

interface Category {
  id: string;
  name: string;
  icon: string | null;
  icon_url: string | null;
  sort_order: number;
  active: boolean;
}

interface CategoryManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function CategoryManager({ adminToken, onRefreshStats }: CategoryManagerProps) {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  
  // Search state
  const [searchTerm, setSearchTerm] = useState('');

  // Form states
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    id: '',
    name: '',
    icon: '',
    icon_url: '',
    sort_order: 0,
    active: true
  });

  const [showAddForm, setShowAddForm] = useState(false);

  // Multi-select state
  const [selectedCategoryIds, setSelectedCategoryIds] = useState<string[]>([]);

  // Drag and drop state
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);
  const originalCategoriesRef = useRef<Category[]>([]);

  const supabaseAdmin = createAdminSupabaseClient(adminToken);

  const fetchCategories = async () => {
    try {
      setLoading(true);
      setError(null);
      const { data, error: fetchErr } = await supabaseAdmin
        .from('categories')
        .select('*')
        .order('sort_order', { ascending: true })
        .order('id', { ascending: true });

      if (fetchErr) throw fetchErr;
      setCategories(data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch categories');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    fetchCategories();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminToken]);

  const showNotification = (type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3000);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4000);
    }
  };

  const handleEdit = (category: Category) => {
    setEditingId(category.id);
    setFormData({
      id: category.id,
      name: category.name,
      icon: category.icon || '',
      icon_url: category.icon_url || '',
      sort_order: category.sort_order,
      active: category.active !== false
    });
    setShowAddForm(false);
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({ id: '', name: '', icon: '', icon_url: '', sort_order: 0, active: true });
  };

  const handleSave = async (id: string) => {
    try {
      if (!formData.name.trim()) {
        showNotification('error', 'Category name is required');
        return;
      }

      const { error: updateErr } = await supabaseAdmin
        .from('categories')
        .update({
          name: formData.name,
          icon: formData.icon || null,
          icon_url: formData.icon_url || null,
          sort_order: Number(formData.sort_order),
          active: formData.active
        })
        .eq('id', id);

      if (updateErr) throw updateErr;

      showNotification('success', 'Category updated successfully');
      setEditingId(null);
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to update category');
    }
  };

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (!formData.id.trim()) {
        showNotification('error', 'Category ID/Slug is required');
        return;
      }
      if (!formData.name.trim()) {
        showNotification('error', 'Category Name is required');
        return;
      }

      // Check if ID already exists
      const idExists = categories.some(cat => cat.id === formData.id.toLowerCase().trim());
      if (idExists) {
        showNotification('error', 'Category ID/Slug already exists');
        return;
      }

      const cleanId = formData.id.toLowerCase().replace(/[^a-z0-9-_]/g, '-').trim();

      const { error: insertErr } = await supabaseAdmin
        .from('categories')
        .insert({
          id: cleanId,
          name: formData.name.trim(),
          icon: formData.icon.trim() || null,
          icon_url: formData.icon_url.trim() || null,
          sort_order: Number(formData.sort_order) || categories.length + 1,
          active: formData.active
        });

      if (insertErr) throw insertErr;

      showNotification('success', 'Category added successfully');
      setFormData({ id: '', name: '', icon: '', icon_url: '', sort_order: 0, active: true });
      setShowAddForm(false);
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to add category');
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this category? This will ALSO permanently delete all channels associated with this category from the database.')) {
      return;
    }

    try {
      // First delete all channels associated with this category
      const { error: channelsDeleteErr } = await supabaseAdmin
        .from('channels')
        .delete()
        .eq('category', id);

      if (channelsDeleteErr) throw channelsDeleteErr;

      // Then delete the category
      const { error: deleteErr } = await supabaseAdmin
        .from('categories')
        .delete()
        .eq('id', id);

      if (deleteErr) throw deleteErr;

      showNotification('success', 'Category and associated channels deleted successfully');
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to delete category and associated channels');
    }
  };

  const handleSelectRow = (id: string) => {
    setSelectedCategoryIds(prev =>
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]
    );
  };

  const handleSelectAll = () => {
    const pageIds = filteredCategories.map(cat => cat.id);
    const allPageSelected = pageIds.length > 0 && pageIds.every(id => selectedCategoryIds.includes(id));

    if (allPageSelected) {
      setSelectedCategoryIds(prev => prev.filter(id => !pageIds.includes(id)));
    } else {
      setSelectedCategoryIds(prev => {
        const otherSelected = prev.filter(id => !pageIds.includes(id));
        return [...otherSelected, ...pageIds];
      });
    }
  };

  const handleBulkDelete = async () => {
    const count = selectedCategoryIds.length;
    if (!confirm(`Are you sure you want to delete the ${count} selected categories? This will ALSO permanently delete all channels associated with these categories.`)) {
      return;
    }

    try {
      setLoading(true);
      // First delete all channels associated with these categories
      const { error: channelsDeleteErr } = await supabaseAdmin
        .from('channels')
        .delete()
        .in('category', selectedCategoryIds);

      if (channelsDeleteErr) throw channelsDeleteErr;

      // Then delete the categories
      const { error: deleteErr } = await supabaseAdmin
        .from('categories')
        .delete()
        .in('id', selectedCategoryIds);

      if (deleteErr) throw deleteErr;

      showNotification('success', `${count} categories deleted successfully`);
      setSelectedCategoryIds([]);
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to delete selected categories');
    } finally {
      setLoading(false);
    }
  };

  const handleBulkActiveChange = async (value: boolean) => {
    const count = selectedCategoryIds.length;
    const actionLabel = value ? 'Activate' : 'Deactivate';
    if (!confirm(`Are you sure you want to ${actionLabel} the ${count} selected categories?`)) {
      return;
    }

    try {
      setLoading(true);
      const { error: updateErr } = await supabaseAdmin
        .from('categories')
        .update({ active: value })
        .in('id', selectedCategoryIds);

      if (updateErr) throw updateErr;

      showNotification('success', `Successfully updated status for ${count} categories`);
      setSelectedCategoryIds([]);
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to update selected categories');
    } finally {
      setLoading(false);
    }
  };

  const handleDragStart = (e: React.DragEvent, index: number) => {
    if (searchTerm) {
      e.preventDefault();
      showNotification('error', 'Please clear search filter before reordering');
      return;
    }
    originalCategoriesRef.current = [...categories];
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', index.toString());
  };

  const handleDragOver = (e: React.DragEvent, index: number) => {
    e.preventDefault();
    if (draggedIndex === null || draggedIndex === index) return;

    // Reorder locally
    const updatedCategories = [...categories];
    const draggedItem = updatedCategories[draggedIndex];
    updatedCategories.splice(draggedIndex, 1);
    updatedCategories.splice(index, 0, draggedItem);

    // Update sort_order values locally based on the new array indices
    const reordered = updatedCategories.map((cat, idx) => ({
      ...cat,
      sort_order: idx + 1,
    }));

    setCategories(reordered);
    setDraggedIndex(index);
  };

  const handleDragEnd = async () => {
    if (draggedIndex === null) return;
    setDraggedIndex(null);

    // Find which categories have actually changed their sort_order
    const changed = categories.filter(cat => {
      const original = originalCategoriesRef.current.find(orig => orig.id === cat.id);
      return !original || original.sort_order !== cat.sort_order;
    });

    if (changed.length === 0) return;

    try {
      setLoading(true);
      const { error: upsertErr } = await supabaseAdmin
        .from('categories')
        .upsert(
          changed.map(cat => ({
            id: cat.id,
            name: cat.name,
            icon: cat.icon,
            icon_url: cat.icon_url,
            sort_order: cat.sort_order,
            active: cat.active
          }))
        );

      if (upsertErr) throw upsertErr;

      showNotification('success', 'Category order updated successfully');
      fetchCategories();
      onRefreshStats();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to save new category order');
      fetchCategories();
    } finally {
      setLoading(false);
    }
  };

  // Filter categories by search term
  const filteredCategories = categories.filter(category => 
    category.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    category.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Header and Controls */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Layers className="text-purple-400 w-6 h-6" />
            Category Management
          </h1>
          <p className="text-xs text-zinc-500 mt-1">Add, update, or remove live streaming categories</p>
        </div>
        <button
          onClick={() => {
            setShowAddForm(!showAddForm);
            handleCancel();
          }}
          className="flex items-center gap-2 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200 shadow-lg shadow-purple-500/20 hover:scale-[1.02]"
        >
          {showAddForm ? <X className="w-4 h-4" /> : <Plus className="w-4 h-4" />}
          {showAddForm ? 'Close Form' : 'Add Category'}
        </button>
      </div>

      {/* Notifications */}
      {error && (
        <div className="p-4 rounded-xl bg-red-950/40 border border-red-900/50 text-red-400 text-sm animate-shake">
          ⚠️ {error}
        </div>
      )}
      {success && (
        <div className="p-4 rounded-xl bg-emerald-950/40 border border-emerald-900/50 text-emerald-400 text-sm animate-fadeIn">
          ✓ {success}
        </div>
      )}

      {/* Add New Category Form */}
      {showAddForm && (
        <form onSubmit={handleAdd} className="p-6 rounded-2xl glass-panel space-y-4 max-w-xl animate-slideDown">
          <h3 className="text-lg font-semibold text-white">Create New Category</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Category ID / Slug</label>
              <input
                type="text"
                placeholder="e.g. sports, movies"
                value={formData.id}
                onChange={e => setFormData({ ...formData, id: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
              <p className="text-[10px] text-zinc-500">Lowercase letters, numbers, dashes only.</p>
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Category Name</label>
              <input
                type="text"
                placeholder="e.g. Sports & Games"
                value={formData.name}
                onChange={e => setFormData({ ...formData, name: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
                required
              />
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Icon Tag / Lucide ID</label>
              <input
                type="text"
                placeholder="e.g. trophy, film, radio"
                value={formData.icon}
                onChange={e => setFormData({ ...formData, icon: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
              <p className="text-[10px] text-zinc-500">Icon keyword used to render in Flutter.</p>
            </div>
            <div className="space-y-1">
              <label className="text-xs font-semibold text-zinc-400">Sort Order</label>
              <input
                type="number"
                value={formData.sort_order}
                onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
            </div>
            <div className="space-y-1 md:col-span-2">
              <label className="text-xs font-semibold text-zinc-400">Icon Image URL</label>
              <input
                type="url"
                placeholder="e.g. https://example.com/icons/sports.png"
                value={formData.icon_url}
                onChange={e => setFormData({ ...formData, icon_url: e.target.value })}
                className="w-full p-2.5 rounded-xl glass-input text-sm"
              />
              <p className="text-[10px] text-zinc-500">Optional URL for category icon image (PNG, SVG, JPG).</p>
            </div>
            <div className="space-y-1 flex items-center gap-3 pt-5">
              <input
                type="checkbox"
                id="active"
                checked={formData.active}
                onChange={e => setFormData({ ...formData, active: e.target.checked })}
                className="w-4 h-4 rounded border-zinc-700 text-purple-600 focus:ring-purple-500 bg-zinc-900"
              />
              <label htmlFor="active" className="text-xs font-semibold text-zinc-400 cursor-pointer">
                Is Active (Show in App)
              </label>
            </div>
          </div>
          <button
            type="submit"
            className="px-5 py-2.5 bg-purple-600 hover:bg-purple-700 text-white rounded-xl text-sm font-semibold transition-all duration-200"
          >
            Save Category
          </button>
        </form>
      )}

      {/* Categories List */}
      <div className="p-6 rounded-2xl glass-panel space-y-4">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-3 top-3 w-4 h-4 text-zinc-500" />
          <input
            type="text"
            placeholder="Search categories by name or slug..."
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
            className="w-full pl-9 pr-4 py-2.5 rounded-xl glass-input text-sm"
          />
        </div>

        {loading ? (
          <div className="text-center py-8 text-zinc-500">Loading categories...</div>
        ) : filteredCategories.length === 0 ? (
          <div className="text-center py-8 text-zinc-500">No categories found.</div>
        ) : (
          <div className="space-y-4">
            {/* Reorder Tip */}
            {!searchTerm && (
              <div className="text-[10px] text-purple-400 flex items-center gap-1 bg-purple-950/20 border border-purple-500/10 px-2 py-0.5 rounded w-max">
                <GripVertical className="w-3 h-3 text-purple-400" />
                <span>Tip: Drag and drop row grip handles to change category order</span>
              </div>
            )}

            {/* Bulk Action Bar */}
            {selectedCategoryIds.length > 0 && (
              <div className="flex flex-wrap items-center justify-between gap-4 p-4 bg-zinc-900/90 border border-zinc-800 rounded-xl animate-fadeIn shadow-lg">
                <div className="flex flex-wrap items-center gap-4 text-xs">
                  <div className="flex items-center gap-2 text-purple-400 font-semibold">
                    <AlertCircle className="w-4 h-4 text-purple-400 animate-pulse" />
                    <span>{selectedCategoryIds.length} categories selected</span>
                  </div>

                  <div className="h-4 w-px bg-zinc-800 hidden md:block" />

                  {/* Bulk Active Status Change */}
                  <div className="flex items-center gap-1.5">
                    <select
                      onChange={async (e) => {
                        const val = e.target.value;
                        if (val === '') return;
                        await handleBulkActiveChange(val === 'true');
                        e.target.value = ''; // Reset select
                      }}
                      className="px-2.5 py-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-zinc-300 text-xs focus:ring-purple-500 focus:outline-none cursor-pointer"
                    >
                      <option value="">Status...</option>
                      <option value="true">Set Active</option>
                      <option value="false">Set Inactive</option>
                    </select>
                  </div>
                </div>

                <button
                  onClick={handleBulkDelete}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white rounded-lg text-xs font-semibold transition cursor-pointer"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                  Delete Selected
                </button>
              </div>
            )}

            {/* Desktop Table View */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full border-collapse text-left text-sm text-zinc-400">
                <thead>
                  <tr className="border-b border-zinc-800 text-zinc-500 text-xs uppercase tracking-wider">
                    <th className="py-3 px-4 w-8 text-center"></th>
                    <th className="py-3 px-4 w-8">
                      <input
                        type="checkbox"
                        checked={filteredCategories.length > 0 && filteredCategories.every(cat => selectedCategoryIds.includes(cat.id))}
                        onChange={handleSelectAll}
                        className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                      />
                    </th>
                    <th className="py-3 px-4 w-16">Sort Order</th>
                    <th className="py-3 px-4">ID/Slug</th>
                    <th className="py-3 px-4">Name</th>
                    <th className="py-3 px-4">Icon Identifier</th>
                    <th className="py-3 px-4">Icon URL</th>
                    <th className="py-3 px-4">Status</th>
                    <th className="py-3 px-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-zinc-800/50">
                  {filteredCategories.map((category) => {
                    const isEditing = editingId === category.id;
                    const absoluteIndex = categories.findIndex(c => c.id === category.id);
                    const isDraggable = true;
                    return (
                      <tr
                        key={category.id}
                        className={`hover:bg-zinc-900/40 transition-colors ${draggedIndex === absoluteIndex ? 'opacity-40 bg-zinc-800/50' : ''}`}
                        draggable={isDraggable}
                        onDragStart={(e) => handleDragStart(e, absoluteIndex)}
                        onDragOver={(e) => handleDragOver(e, absoluteIndex)}
                        onDragEnd={handleDragEnd}
                      >
                        <td className="py-3 px-1 text-center w-8 text-zinc-650 hover:text-zinc-400 cursor-grab active:cursor-grabbing">
                          <GripVertical className="w-4 h-4 mx-auto" />
                        </td>
                        <td className="py-3 px-4">
                          <input
                            type="checkbox"
                            checked={selectedCategoryIds.includes(category.id)}
                            onChange={() => handleSelectRow(category.id)}
                            className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                          />
                        </td>
                        <td className="py-3 px-4">
                          {isEditing ? (
                            <input
                              type="number"
                              value={formData.sort_order}
                              onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                              className="w-20 p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                            />
                          ) : (
                            <span className="font-mono text-zinc-500">{category.sort_order}</span>
                          )}
                        </td>
                        <td className="py-3 px-4">
                          <span className="font-mono text-xs px-2 py-0.5 rounded bg-zinc-800 text-purple-300">
                            {category.id}
                          </span>
                        </td>
                        <td className="py-3 px-4 text-white font-semibold">
                          {isEditing ? (
                            <input
                              type="text"
                              value={formData.name}
                              onChange={e => setFormData({ ...formData, name: e.target.value })}
                              className="w-full max-w-xs p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                            />
                          ) : (
                            category.name
                          )}
                        </td>
                        <td className="py-3 px-4">
                          {isEditing ? (
                            <input
                              type="text"
                              value={formData.icon}
                              onChange={e => setFormData({ ...formData, icon: e.target.value })}
                              className="w-full max-w-xs p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                            />
                          ) : (
                            <span className="text-zinc-500 font-mono text-xs">{category.icon || '—'}</span>
                          )}
                        </td>
                        <td className="py-3 px-4">
                          {isEditing ? (
                            <input
                              type="text"
                              value={formData.icon_url}
                              onChange={e => setFormData({ ...formData, icon_url: e.target.value })}
                              className="w-full max-w-xs p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white"
                              placeholder="Image URL"
                            />
                          ) : (
                            <span className="text-zinc-500 font-mono text-xs truncate max-w-[150px] block" title={category.icon_url || ''}>
                              {category.icon_url || '—'}
                            </span>
                          )}
                        </td>
                        <td className="py-3 px-4">
                          {isEditing ? (
                            <input
                              type="checkbox"
                              checked={formData.active}
                              onChange={e => setFormData({ ...formData, active: e.target.checked })}
                              className="w-4 h-4 rounded border-zinc-700 text-purple-600 focus:ring-purple-500 bg-zinc-900"
                            />
                          ) : (
                            <span className={`px-2 py-0.5 rounded text-[10px] font-semibold ${
                              category.active !== false 
                                ? 'bg-emerald-950/60 text-emerald-400 border border-emerald-900/50' 
                                : 'bg-zinc-850 text-zinc-500 border border-zinc-700'
                            }`}>
                              {category.active !== false ? 'Active' : 'Inactive'}
                            </span>
                          )}
                        </td>
                        <td className="py-3 px-4 text-right">
                          {isEditing ? (
                            <div className="flex justify-end gap-2">
                              <button
                                onClick={() => handleSave(category.id)}
                                className="p-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg transition-colors cursor-pointer"
                                title="Save changes"
                              >
                                <Save className="w-3.5 h-3.5" />
                              </button>
                              <button
                                onClick={handleCancel}
                                className="p-2 bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white rounded-lg transition-colors cursor-pointer"
                                title="Cancel"
                              >
                                <X className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          ) : (
                            <div className="flex justify-end gap-2">
                              <button
                                onClick={() => handleEdit(category)}
                                className="p-2 bg-zinc-900 hover:bg-zinc-800 text-purple-400 hover:text-white rounded-lg border border-zinc-800 hover:border-zinc-700 transition-colors cursor-pointer"
                                title="Edit Category"
                              >
                                <Edit2 className="w-3.5 h-3.5" />
                              </button>
                              <button
                                onClick={() => handleDelete(category.id)}
                                className="p-2 bg-zinc-900 hover:bg-red-950/40 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 hover:border-red-900/50 transition-colors cursor-pointer"
                                title="Delete Category"
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Mobile Card View */}
            <div className="block md:hidden space-y-4">
              {filteredCategories.map((category) => {
                const isEditing = editingId === category.id;
                return (
                  <div key={category.id} className="p-4 rounded-xl bg-zinc-900/40 border border-zinc-805 space-y-3">
                    <div className="flex justify-between items-center border-b border-zinc-800/60 pb-2">
                      <div className="flex items-center gap-2">
                        <input
                          type="checkbox"
                          checked={selectedCategoryIds.includes(category.id)}
                          onChange={() => handleSelectRow(category.id)}
                          className="rounded border-zinc-700 bg-zinc-950 text-purple-600 focus:ring-purple-500 cursor-pointer"
                        />
                        <span className="font-mono text-xs px-2 py-0.5 rounded bg-zinc-800 text-purple-300">
                          {category.id}
                        </span>
                      </div>
                      {isEditing ? (
                        <div className="flex gap-2">
                          <button
                            onClick={() => handleSave(category.id)}
                            className="p-1.5 bg-emerald-600 text-white rounded-lg cursor-pointer"
                            title="Save"
                          >
                            <Save className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={handleCancel}
                            className="p-1.5 bg-zinc-800 text-zinc-400 rounded-lg cursor-pointer"
                            title="Cancel"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ) : (
                        <div className="flex gap-1.5">
                          <button
                            onClick={() => handleEdit(category)}
                            className="p-1.5 bg-zinc-950 hover:bg-zinc-850 text-purple-400 hover:text-white rounded-lg border border-zinc-800 cursor-pointer"
                            title="Edit"
                          >
                            <Edit2 className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => handleDelete(category.id)}
                            className="p-1.5 bg-zinc-950 hover:bg-red-950/20 text-red-400 hover:text-red-300 rounded-lg border border-zinc-800 cursor-pointer"
                            title="Delete"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      )}
                    </div>

                    <div className="space-y-2 text-xs">
                      <div className="flex justify-between items-center">
                        <span className="text-zinc-500">Name</span>
                        {isEditing ? (
                          <input
                            type="text"
                            value={formData.name}
                            onChange={e => setFormData({ ...formData, name: e.target.value })}
                            className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-44"
                          />
                        ) : (
                          <span className="text-white font-semibold">{category.name}</span>
                        )}
                      </div>

                      <div className="flex justify-between items-center">
                        <span className="text-zinc-500">Icon Tag</span>
                        {isEditing ? (
                          <input
                            type="text"
                            value={formData.icon}
                            onChange={e => setFormData({ ...formData, icon: e.target.value })}
                            className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-44"
                          />
                        ) : (
                          <span className="font-mono text-zinc-400 bg-zinc-950/50 px-1.5 py-0.5 rounded border border-zinc-850">{category.icon || '—'}</span>
                        )}
                      </div>

                      <div className="flex justify-between items-center">
                        <span className="text-zinc-500">Icon URL</span>
                        {isEditing ? (
                          <input
                            type="text"
                            value={formData.icon_url}
                            onChange={e => setFormData({ ...formData, icon_url: e.target.value })}
                            className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-44"
                            placeholder="Image URL"
                          />
                        ) : (
                          <span className="font-mono text-zinc-400 bg-zinc-950/50 px-1.5 py-0.5 rounded border border-zinc-850 truncate max-w-[150px]" title={category.icon_url || ''}>{category.icon_url || '—'}</span>
                        )}
                      </div>

                      <div className="flex justify-between items-center">
                        <span className="text-zinc-500">Status</span>
                        {isEditing ? (
                          <input
                            type="checkbox"
                            checked={formData.active}
                            onChange={e => setFormData({ ...formData, active: e.target.checked })}
                            className="w-4 h-4 rounded border-zinc-700 text-purple-600 bg-zinc-900"
                          />
                        ) : (
                          <span className={`px-2 py-0.5 rounded text-[10px] font-semibold ${
                            category.active !== false 
                              ? 'bg-emerald-950/60 text-emerald-400 border border-emerald-900/50' 
                              : 'bg-zinc-850 text-zinc-500 border border-zinc-700'
                          }`}>
                            {category.active !== false ? 'Active' : 'Inactive'}
                          </span>
                        )}
                      </div>

                      <div className="flex justify-between items-center">
                        <span className="text-zinc-500">Sort Order</span>
                        {isEditing ? (
                          <input
                            type="number"
                            value={formData.sort_order}
                            onChange={e => setFormData({ ...formData, sort_order: Number(e.target.value) })}
                            className="p-1.5 rounded bg-zinc-950 border border-zinc-800 text-xs text-white w-20"
                          />
                        ) : (
                          <span className="font-mono text-zinc-300">{category.sort_order}</span>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
