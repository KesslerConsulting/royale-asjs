////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.html.beads
{	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.ContainerBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IScrollingLayoutParent;
	import org.apache.flex.core.IParent;
    import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.Strand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.html.beads.models.SingleLineBorderModel;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.html.supportClasses.DataGroup;
	import org.apache.flex.html.supportClasses.ScrollBar;

	/**
	 *  The List class creates the visual elements of the org.apache.flex.html.List 
	 *  component. A List consists of the area to display the data (in the dataGroup), any 
	 *  scrollbars, and so forth.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ListView extends ContainerView implements IListView
	{
		public function ListView()
		{
		}
						
		private var listModel:ISelectionModel;
		
		private var _border:Border;
		
		/**
		 *  The border surrounding the org.apache.flex.html.List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get border():Border
        {
            return _border;
        }
		
		private var _dataGroup:IItemRendererParent;
		
		/**
		 *  The area holding the itemRenderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataGroup():IItemRendererParent
		{
			return _dataGroup;
		}
		public function set dataGroup(value:IItemRendererParent):void
		{
			_dataGroup = value;
		}
		
		/**
		 *  The contentArea includes the dataGroup and scrollBars.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function get contentView():IParentIUIBase
		{
			return _dataGroup as IParentIUIBase;
		}
		
		/**
		 * @private
		 */
		override public function get resizableView():IUIBase
		{
			return _strand as IUIBase;
		}
        
        /**
         * @private
         */
        override public function get host():IUIBase
        {
            return _strand as IUIBase;
        }
        
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}
		
		override protected function completeSetup():void
		{
			super.completeSetup();
			IEventDispatcher(_strand).addEventListener("itemsCreated", performLayout);
			
			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
		}
		
		override protected function createContentView():IParentIUIBase
		{
			if (_dataGroup == null) {
				_dataGroup = new (ValuesManager.valuesImpl.getValue(_strand, "iDataGroup")) as IItemRendererParent;
			}
			return _dataGroup as IParentIUIBase;
		}
		
		private var lastSelectedIndex:int = -1;
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			// override if needed
			performLayout(event);
		}
		
		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			if (lastSelectedIndex != -1)
			{
				var ir:ISelectableItemRenderer = dataGroup.getItemRendererForIndex(lastSelectedIndex) as ISelectableItemRenderer;
                ir.selected = false;
			}
			if (listModel.selectedIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as ISelectableItemRenderer;
	            ir.selected = true;
			}
            lastSelectedIndex = listModel.selectedIndex;
		}
		
		private var lastRollOverIndex:int = -1;
		
		/**
		 * @private
		 */
		private function rollOverIndexChangeHandler(event:Event):void
		{
			if (lastRollOverIndex != -1)
			{
				var ir:ISelectableItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as ISelectableItemRenderer;
                ir.hovered = false;
			}
			if (IRollOverModel(listModel).rollOverIndex != -1)
			{
	            ir = dataGroup.getItemRendererForIndex(IRollOverModel(listModel).rollOverIndex) as ISelectableItemRenderer;
	            ir.hovered = true;
			}
			lastRollOverIndex = IRollOverModel(listModel).rollOverIndex;
		}
        
        /**
         *  respond to a change in size or request to re-layout everything
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override protected function resizeHandler(event:Event):void
		{
			super.resizeHandler(event);
			_dataGroup.updateAllItemRenderers();
		}
				
        /**
         *  @copy org.apache.flex.core.IBeadView#viewHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override public function get viewHeight():Number
        {
            // don't want to put $height in an interface
            return _strand["$height"];
        }
        
        /**
         *  @copy org.apache.flex.core.IBeadView#viewWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override public function get viewWidth():Number
        {
            // don't want to put $width in an interface
            return _strand["$width"];
        }
	}
}
