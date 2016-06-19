--ＳーＶｉｎｅ(セイクリド・ヴァイン)の騎士－クライッシャ
function c101010240.initial_effect(c)
	--Once per turn, during either player's turn: You can banish 1 card from your hand, then target 1 card on the field, then apply the effect based on its type. (If the target is Set, reveal it first.) ● Monster: Banish it. ● Spell: Shuffle it into the Deck. ● Trap: Return it to the hand.
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010240.cost)
	ae1:SetTarget(c101010240.tg)
	ae1:SetOperation(c101010240.op)
	c:RegisterEffect(ae1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,20004000)
	e1:SetCondition(c101010240.spcon)
	e1:SetOperation(c101010240.spop)
	e1:SetValue(0x7150)
	c:RegisterEffect(e1)
	--cannot release (Do Not Remove)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	--cannot be XYZ (Do Not Remove)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--identifier
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(20004000)
	c:RegisterEffect(e9)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_TO_GRAVE)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge2:SetOperation(function(e) local c=e:GetHandler() Duel.SendtoHand(c,nil,REASON_RULE) if not c:IsLocation(LOCATION_EXTRA) then Duel.SendtoDeck(c,nil,0,REASON_RULE) end end)
	c:RegisterEffect(ge2)
end
function c101010240.spfilter(c)
	if not c:IsAbleToRemoveAsCost() or c:IsRankAbove(1) then return false end
	local atk=c:GetAttack()
	local lv=c:GetLevel()
	local st1=atk
	local st2=lv
	local mhb=st1/st2
	while mhb>=10 or mhb<1 do
		while mhb>=10 do mhb=mhb/10 end
		while mhb<1 do mhb=mhb*10 end
	end
	local mhc=mhb-math.floor(mhb)
	if mhc>=0.5 then mhb=math.ceil(mhb) else mhb=math.floor(mhb) end
	return mhb==8 or mhb==math.ceil(8/2) or mhb==math.floor(8/2)
end
function c101010240.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c101010240.spfilter,tp,LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(743000003)==0
end
function c101010240.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ec=Duel.GetMatchingGroup(c101010240.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	local g=Duel.SelectMatchingCard(tp,c101010240.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c101010240.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetLabel(x)
	e3:SetTarget(c101010240.reptg)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
	--cannot release (Do Not Remove)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
end
function c101010240.spatial(c)
	return c:IsType(TYPE_XYZ) and (c:IsHasEffect(20001000) or c:IsHasEffect(20002000) or c:IsHasEffect(20003000) or c:IsHasEffect(20004000))
end
function c101010240.splimit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(743000003,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c101010240.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	local ck=false
	if Duel.CheckEvent(EVENT_SPSUMMON) or c:GetRank()<=1 or c:IsLocation(LOCATION_OVERLAY) then ck=true end
	if ck then
		if Duel.Remove(c,POS_FACEUP,r)==0 then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,r)
			if not c:IsLocation(LOCATION_EXTRA) then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,0,r)
			end
		end
		return true
	end
	local dje=e:GetLabel()
	dje:SetLabel(dje-1)
	if c:GetFlagEffect(201010240)==0 then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CHANGE_RANK)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e9:SetRange(LOCATION_MZONE)
		e9:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
		e9:SetLabelObject(dje)
		c:RegisterEffect(e9)
		c:RegisterFlagEffect(201010240,RESET_EVENT+0x1fe0000,0,1)
	end
	return true
end
function c101010240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010240.tfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c101010240.filter(c,c:GetOriginalType())
end
function c101010240.filter(c,typ)
	if bit.band(typ,TYPE_MONSTER)==TYPE_MONSTER then
		return c:IsAbleToRemove()
	elseif bit.band(typ,TYPE_SPELL)==TYPE_SPELL then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function c101010240.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010240.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	local cat=CATEGORY_TOHAND
	if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then cat=CATEGORY_REMOVE elseif bit.band(g:GetFirst():GetOriginalType(),TYPE_SPELL)==TYPE_SPELL then cat=CATEGORY_TODECK end
	e:SetCategory(cat)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,cat,g,1,0,0)
end
function c101010240.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_MONSTER) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		if tc:IsType(TYPE_SPELL) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		if tc:IsType(TYPE_TRAP) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	end
end
