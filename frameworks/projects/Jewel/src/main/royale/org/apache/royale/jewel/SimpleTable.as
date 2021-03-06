
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
package org.apache.royale.jewel
{
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The SimpleTable class represents a simple HTML <table> element.
	 *  This component is designed to be declarative in MXML (or AS3),
	 *  Check Table component for a Table that uses itemRenderers, columns
	 *  and a data provider.
	 *  
	 *  This component uses the following jewel classes to generate the 
	 *  Table structure:
	 *  
	 *  - Header:
	 * 		j:THead
	 *			j:TableRow
	 * 				j:TableHeaderCell
	 * 
	 *  - Body
	 * 		j:TBody
	 * 			j:TableRow
	 * 				j:TableCell
	 * 
	 * 	- Footer
	 * 		j:TFoot
	 * 			j:TableRow
	 * 				j:TableCell
	 *
	 * 
	 *  As well, DataGrid is a more complex component
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SimpleTable extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SimpleTable()
		{
			super();
			
			typeNames = "jewel simpletable";
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            return addElementToWrapper(this, 'table');
        }
    }
}
