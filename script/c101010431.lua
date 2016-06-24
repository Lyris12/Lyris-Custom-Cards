--Osa, Princess of Stellar Vine
local id,ref=GIR()
function ref.start(c)
	--to grave
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(ref.cost)
	ae1:SetTarget(ref.target)
	ae1:SetOperation(ref.op)
	c:RegisterEffect(ae1)
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
ref.spatial=true
--Spatial Formula filter(s)
ref.material1=function(mc) return c:IsAttribute(ATTRIBUTE_WATER) end
ref.material2=function(mc) return c:IsAttribute(ATTRIBUTE_WATER) end -- Invert this block of code on Division Spatial Monsters (begin)
ref.mult_spatial=true --choose 1, depending on the Spatial Formula
-- ref.divs_spatial=true --Division Procedure /
-- ref.stat=function(mc) return mc:GetAttack() or mc:GetDefence() or mc:GetAttack()-mc:GetDefence() end
-- ref.indicator=function(mc) return mc:GetLevel() or mc:GetRank() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToGraveAsCost()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010238,0))
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct==3 and Duel.SelectYesNo(tp,aux.Stringid(101010238,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
