--Victory Dragon Libraker
local id,ref=GIR()
function ref.start(c)
--Xyz Summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--dispose
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return bit.band(e:GetHandler():GetSummonType(),0x8773)==0x8773 end)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
	--detach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetCurrentPhase()==PHASE_MAIN1 end)
	e2:SetCost(ref.cost)
	e2:SetTarget(ref.mptg)
	e2:SetOperation(ref.mpop)
	c:RegisterEffect(e2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.relay=true
ref.point=3
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10001100)>0 and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	local t={}
	local i=1
	local p=1
	local lv=c:GetFlagEffectLabel(10001100)
	for i=1,lv do 
		if not Duel.IsPlayerCanDiscardDeck(1-tp,i) then break end
		t[p]=i p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local ct=Duel.AnnounceNumber(tp,table.unpack(t))
	if lv==ct then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,lv-ct)
	end
	Debug.ShowHint(tostring(ct) .. " Point(s) removed")
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,e:GetLabel(),REASON_EFFECT)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.mptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
end
function ref.mpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--disable
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ATTACK_ANNOUNCE)
		e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetAttackTarget()~=nil end)
		e4:SetOperation(ref.disop)
		e4:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
	end
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
