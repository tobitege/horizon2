--@require UIController
--@require UI
CSS =
    [[
    #horizon {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      font-family: 'Play';
      font-weight: 1;
      font-size: 1vh;
    }
    :root {
      /* 0faea9 */
      --primary: #ae0f12;
      --secondary: #fff;
      --bg: #55555577;
      --bg2: #44444444;
      --border: 0.05em solid var(--secondary);
      --border-primary: 0.05em solid var(--primary);
      --glow: 0 0 0.25vw 0.05vw var(--primary);
      --text-glow: 0 0 0.25vw var(--primary);
      --spacing: 0.25em;
    }
    * {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    svg {
        position: relative !important;
    }
    uicursor {
        display: block;
        position: absolute;
        width: 2vh;
        height: 2vh;
        z-index: 999;
    }
    readout {
        display: inline;
        text-shadow: 0 0 0.5vh #000000ff;
        text-align: center;
        color:#fff;
        letter-spacing:0.25px;
        -webkit-text-stroke-width: 2px;
        -webkit-text-stroke-color: #000000bb;
        font-weight: 100;
    }
    panel {
      display: flex;
      flex-direction: column;
      position: absolute;
      letter-spacing: 0.05vw;
      text-transform: uppercase;
    }
    panel.row {
      flex-direction: row;
    }
    panel:not(.row) > *:not(:last-child) {
      margin-bottom: var(--spacing);
    }
    panel.row > *:not(:last-child) {
      margin-right: var(--spacing);
    }
    panel.filled {
        box-sizing: border-box;
        background: var(--bg);
        border: 1px solid #ae0f1233;
        box-sizing: border-box;
    }
    panel.filled::after {
        position: absolute;
        border: 1px solid #ffffff77;
        border-width: 1px 0 0 1px;
        border-radius: 0;
        content: "";
        width: 0.5vmax;
        height: 0.5vmax;
        top: 0px;
        left: 0px;
    }
    panel.filled::before{
        position: absolute; 
        border: 1px solid #ffffff77;
        border-width: 0 1px 1px 0;
        border-radius: 0;
        content: "";
        width: 0.5vmax;
        height: 0.5vmax;
        bottom: 0px;
        right: 0px;
    }
    .left {
      text-align: left;
    }
    .rel {
      position: relative;
    }
    uiprogress {
        height: 0.5vw;
        border-left: var(--border);
        border-right: var(--border);
        background-color: var(--bg);
    }
    uivprogress {
        position: relative;
        border-top: var(--border);
        border-bottom: var(--border);
        background-color: var(--bg);
        width: 0.75em;
        z-index: 10;
    }
    uivprogress > inner {
        position: absolute;
        display: block;
        background-color: var(--primary);
        width: 33%;
        left: 33%;
        bottom: 0.05em;
        box-shadow: var(--glow);
        max-height: calc(100% - 0.05em);
    }
    uiprogress > inner {
        position: relative;
        display: block;
        background-color: var(--primary);
        height: 33%;
        top: 50%;
        left: 0.05em;
        transform: translateY(-33%);
        box-shadow: var(--glow);
        max-width: calc(100% - 0.05em);
        overflow: hidden;
    }
    uiprogress[data-label] {
        margin-left: 1.8em;
    }
    panel.filled > uiprogress[data-label] {
        margin-left: 2.3em;
    }
    panel.filled > uiprogress[data-label]::before {
        left: 1.5em;
    }
    uiprogress[data-label]::before {
        display: block;
        position: absolute;
        left: 0;
        content: attr(data-label);
        color: var(--secondary);
        font-size: 0.74em;
        font-weight: 500;
        padding-top: 0.05em;
        text-shadow: var(--text-glow);
    }
    uispacer {
        display: block;
        height: 1vh;
    }
    uilabel {
        color: var(--secondary);
        font-size: 1.25em;
        letter-spacing: 0;
        border-left: var(--border-primary);
        padding-left: 0.33vw;
        text-transform: uppercase;
        text-shadow: var(--text-glow);
        background: var(--bg2);
        padding-top: 0.25em;
        padding-right: 0.15em;
    }
    uiheading {
        color: var(--secondary);
        position: absolute;
        display: block;
        text-transform: uppercase;
        text-align: center;
        font-size: 1.25em;
        padding: 0.2vmax;
        background: var(--bg);
    }
    uiheading::before {
        content: "";
        left: 0;
        bottom: 0;
        display: block;
        position: absolute;
        background: var(--primary);
        width: 15%;
        height: 0.1em;
        box-shadow: var(--glow);
    }
    uiheading::after {
        content: "";
        right: 0;
        bottom: 0;
        display: block;
        position: absolute;
        background: var(--primary);
        width: calc(85% - 0.2em);
        height: 0.1em;
        box-shadow: var(--glow);
    }
    uiinstrument {
        background: var(--bg);
        border-left: var(--border);
        border-right: var(--border);
    }
]]

Horizon.GetModule("UI Controller").Add(UICore(SystemDisplay,CSS))